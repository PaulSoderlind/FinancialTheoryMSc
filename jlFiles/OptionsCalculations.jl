function BuildSTree(S,n,u,d)
    STree = [fill(NaN,i) for i = 1:n+1]  #vector of vectors (of different lengths)
    STree[1][1] = S                      #time node 1, element 1
    for i = 2:n+1                        #move forward in time
        STree[i][1:end-1] = u*STree[i-1]   #up move from STree[i-1][1:end]
        STree[i][end] = d*STree[i-1][end]  #down move from STree[i-1][end]
    end
    return STree
end

function EuOptionPrice(STree,K,y,n,h,u,d,p,isPut=false)     #price of European option
    Value = deepcopy(STree)                          #tree for derivative, to fill
    if isPut
        Value[n+1] = max.(0,K.-STree[n+1])            #put, at last time node
    else
        Value[n+1] = max.(0,STree[n+1].-K)            #call, at last time node
    end
    for i = n:-1:1                                   #move backward in time
        Value[i] = exp(-y*h)*(p*Value[i+1][1:end-1] + (1-p)*Value[i+1][2:end])
    end                                           #p*up + (1-p)*down, discount
    return Value
end

function AmOptionPrice(STree,K,y,n,h,u,d,p,isPut=false)     #price of American option
    Value = deepcopy(STree)                          #tree for derivative, to fill
    if isPut
        Value[n+1] = max.(0,K.-STree[n+1])            #put, at last time node
    else
        Value[n+1] = max.(0,STree[n+1].-K)            #call, at last time node
    end
    for i = n:-1:1                                   #move backward in time
        fa  = exp(-y*h)*(p*Value[i+1][1:end-1] + (1-p)*Value[i+1][2:end])
        if isPut
            Value[i] = max.(K.-STree[i],fa)         #put
        else
            Value[i] = max.(STree[i].-K,fa)         #call
        end
    end
    return Value
end

function Φ(x)
    #Calculates Pr(z<=x) for N(0,1) variable z
    Pr = cdf(Normal(0,1),x)
    return Pr
end

function OptionBlackSPs(S,K,m,y,σ,δ=0,PutIt=false)
    #Calculates Black-Scholes European call or put option price, continuous dividends of δ
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
