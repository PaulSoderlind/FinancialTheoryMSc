"""
CRRparams(σ,m,n,y)

    BOPM parameters according to CRR
"""
function CRRparams(σ,m,y,n)
    h = m/n                 #time step size (in years)
    u = exp(σ*sqrt(h))      #up move
    d = exp(-σ*sqrt(h))     #down move
    p = (exp(y*h) - d)/(u-d) #rn prob of up move
    return h,u,d,p
end


"""
    BuildSTree(S,n,u,d)

Build binomial tree, starting at `S` and having `n` steps with up move `u` and down move `d`

# Output
- `STree:: Vector or vectors`: each (sub-)vector is for a time step. `STree[0] = [S]` and `STree[n]` is for time period n.

"""
function BuildSTree(S,n,u,d)
    STree = [fill(NaN,i) for i = 1:n+1]  #vector of vectors (of different lengths)
    STree = OffsetArray(STree,0:n)       #convert so the indices are 0:n
    STree[0][1] = S                      #step 0 is in STree[0], element 1
    for i in 1:n                          #move forward in time
        STree[i][1:end-1] = u*STree[i-1]   #up move from STree[i-1][1:end]
        STree[i][end] = d*STree[i-1][end]  #down move from STree[i-1][end]
    end
    return STree
end


"""
    EuOptionPrice(STree,K,y,h,p;isPut=false)

Calculate price of European option from binomial model

# Output
- `Value:: Vector of vectors`: option values at different nodes, same structure as STree

"""
function EuOptionPrice(STree,K,y,h,p;isPut=false)     #price of European option
    Value    = similar(STree)                            #tree for derivative, to fill
    n        = length(STree) - 1                         #number of steps in STree
    Value[n] = isPut ? max.(0,K.-STree[n]) : max.(0,STree[n].-K) #last time node
    for i in n-1:-1:0                                   #move backward in time
        Value[i] = exp(-y*h)*(p*Value[i+1][1:end-1] + (1-p)*Value[i+1][2:end])
    end                                           #p*up + (1-p)*down, discount
    return Value
end

"""
    AmOptionPrice(STree,K,y,h,p;isPut=false)

Calculate price of American option from binomial model

# Output
- `Value:: Vector of vectors`: option values at different nodes, same structure as STree
- `Exerc:: Vector of vectors`: true if early exercise at the node, same structure as STree

"""
function AmOptionPrice(STree,K,y,h,p;isPut=false)     #price of American option
    Value = similar(STree)                            #tree for derivative, to fill
    n     = length(STree) - 1
    Exerc = similar(Value,BitArray)               #same structure as STree, but BitArrays, empty
    Value[n] = isPut ? max.(0,K.-STree[n]) : max.(0,STree[n].-K)        #last time node
    Exerc[n] = Value[n] .> 0                      #exercise
    for i in n-1:-1:0                                    #move backward in time
        fa  = exp(-y*h)*(p*Value[i+1][1:end-1] + (1-p)*Value[i+1][2:end])
        Value[i] = isPut ? max.(K.-STree[i],fa) : max.(STree[i].-K,fa)    #put or call
        Exerc[i] = Value[i] .> fa                   #early exercise
    end
    return Value, Exerc
end

"""
    BOPM_European(S,K,m,y,σ;isPut=false,n=250)

Calculate European CRR/BOPM option price. Wraps functions for the CRR parameters,
building the tree of the underlying asset and finally the BOPM calculations.
"""
function BOPM_European(S,K,m,y,σ;isPut=false,n=250)
    (h,u,d,p) = CRRparams(σ,m,y,n)
    STree     = BuildSTree(S,n,u,d)
    price     = EuOptionPrice(STree,K,y,h,p;isPut)[0][]
    return price
end

"""
    BOPM_American(S,K,m,y,σ;isPut=false,n=250)

Calculate American CRR/BOPM option price. Wraps functions for the CRR parameters,
building the tree of the underlying asset and finally the BOPM calculations.
"""
function BOPM_American(S,K,m,y,σ;isPut=false,n=250)
    (h,u,d,p) = CRRparams(σ,m,y,n)
    STree     = BuildSTree(S,n,u,d)
    price     = AmOptionPrice(STree,K,y,h,p;isPut)[1][0][1]
    return price
end
#------------------------------------------------------------------------------

"""
    Φ(x)

Calculate Pr(z<=x) for N(0,1) variable z
"""
function Φ(x)
    Pr = cdf(Normal(0,1),x)
    return Pr
end


"""
    OptionBlackSPs(S,K,m,y,σ,δ=0;isPut=false)

Calculate Black-Scholes European call or put option price, continuous dividends of δ
"""
function OptionBlackSPs(S,K,m,y,σ,δ=0;isPut=false)
    d1 = ( log(S/K) + (y-δ+0.5*σ^2)*m ) / (σ*sqrt(m))
    d2 = d1 - σ*sqrt(m)
    c  = exp(-δ*m)*S*Φ(d1) - K*exp(-y*m)*Φ(d2)
    price = isPut ? c - exp(-δ*m)*S + exp(-y*m)*K : c
    return price
end
