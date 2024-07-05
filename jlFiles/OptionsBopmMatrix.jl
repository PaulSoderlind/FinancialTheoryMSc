"""
Build a Tree for the underlying asset. Storing in a matrix.
"""
function BuildSTreeM(S,n,u,d)
    STree = fill(NaN,1+n,1+n)
    STree[1,1] = S       #time step 0
    for i in 1:n         #loop over time
        i1             = i + 1               #index of time step i in matrix 
        S_1            = STree[1:i1-1,i1-1]  #get values in time step i-1
        STree[1:i1,i1] = [u*S_1;d*S_1[end]]  #save in the right place
    end
    return STree
end


"""
    EuOptionPriceM(STree,K,y,h,p;isPut=false)

Calculate price of European option from binomial model. Storing in a matrix.

## Output
- `Value:: Matrix`: option values at different nodes, same structure as STree

"""
function EuOptionPriceM(STree,K,y,h,p;isPut=false)
    Value    = similar(STree)                            #tree for derivative, to fill
    Value   .= NaN
    n        = size(STree,2) - 1                         #number of time steps in STree
    Sn       = STree[:,n+1]
    Value[:,n+1] = isPut ? max.(0,K.-Sn) : max.(0,Sn.-K)  #last time node
    for i = n-1:-1:0                                   #move backward in time
        i1 = i + 1
        Value[1:i1,i1] = exp(-y*h)*(p*Value[1:i1,i1+1] + (1-p)*Value[2:i1+1,i1+1])
    end                                           #p*up + (1-p)*down, discount
    return Value
end
