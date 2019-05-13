"""
    BuildSTree(S,n,u,d)

Build binomial tree, starting at `S` and having `n` steps with up steps `u` and down steps `d`
"""
function BuildSTree(S,n,u,d)
    STree = [fill(NaN,i) for i = 1:n+1]  #vector of vectors (of different lengths)
    STree[1][1] = S                      #time node 1, element 1
    for i = 2:n+1                        #move forward in time
        STree[i][1:end-1] = u*STree[i-1]   #up move from STree[i-1][1:end]
        STree[i][end] = d*STree[i-1][end]  #down move from STree[i-1][end]
    end
    return STree
end


"""
    EuOptionPrice(STree,K,y,h,p,isPut=false)

Calculate price of European option from binomial model

"""
function EuOptionPrice(STree,K,y,h,p,isPut=false)
    Value = deepcopy(STree)                           #tree for derivative, to fill
    n     = length(STree) - 1                         #number of steps in STree
    if isPut
        Value[n+1] = max.(0,K.-STree[n+1])            #put, at last time node
    else
        Value[n+1] = max.(0,STree[n+1].-K)            #call, at last time node
    end
    for i = n:-1:1                                    #move backward in time
        Value[i] = exp(-y*h)*(p*Value[i+1][1:end-1] + (1-p)*Value[i+1][2:end])
    end                                           #p*up + (1-p)*down, discount
    return Value
end

"""
    AmOptionPrice(STree,K,y,h,p,isPut=false)

Calculate price of American option from binomial model
"""
function AmOptionPrice(STree,K,y,h,p,isPut=false)     #price of American option
    Value = deepcopy(STree)                           #tree for derivative, to fill
    n     = length(STree) - 1
    Exerc = [falses(i) for i = 1:length(STree)]
    if isPut
        Value[n+1] = max.(0,K.-STree[n+1])            #put, at last time node
    else
        Value[n+1] = max.(0,STree[n+1].-K)            #call, at last time node
    end
    Exerc[n+1] = Value[n+1] .> 0                      #exercise
    for i = n:-1:1                                    #move backward in time
        fa  = exp(-y*h)*(p*Value[i+1][1:end-1] + (1-p)*Value[i+1][2:end])
        if isPut
            Value[i] = max.(K.-STree[i],fa)         #put
        else
            Value[i] = max.(STree[i].-K,fa)         #call
        end
        Exerc[i] = Value[i] .> fa                   #early exercise
    end
    return Value, Exerc
end


"""
    Φ(x)

Calculate Pr(z<=x) for N(0,1) variable z
"""
function Φ(x)
    Pr = cdf(Normal(0,1),x)
    return Pr
end


"""
    OptionBlackSPs(S,K,m,y,σ,δ=0,PutIt=false)

Calculate Black-Scholes European option price, continuous dividends of δ
"""
function OptionBlackSPs(S,K,m,y,σ,δ=0,PutIt=false)
    d1 = ( log(S/K) + (y-δ+0.5*σ^2)*m ) / (σ*sqrt(m))
    d2 = d1 - σ*sqrt(m)
    c  = exp(-δ*m)*S*Φ(d1) - K*exp(-y*m)*Φ(d2)
    if PutIt
        price = c - exp(-δ*m)*S + exp(-y*m)*K
    else
        price = c
    end
    return price
end
