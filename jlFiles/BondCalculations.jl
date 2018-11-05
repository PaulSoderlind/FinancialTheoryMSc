"""
Y:  scalar or K vector of interest rates
cf: scalar or K vector of cash flows
m: K vector of times for the cash flows
"""
function BondPrice3(Y,cf,m)              #cf is a vector of all cash flows at times m
    cdisc = cf./((Y.+1).^m)                #c/(1+y1)^m1, c/(1+y2)^m2 + ...
    P     = sum(cdisc)                     #price
    return P
end
