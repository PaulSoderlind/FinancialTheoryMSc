"""
    BondPrice3(Y,cf,m)

Calculate bond price as sum of discounted cash flows.

# Input:
- Y:  scalar or K vector of interest rates
- cf: K vector of cash flows
- m:  K vector of times for the cash flows
"""
function BondPrice3(Y,cf,m)              #cf is a vector of all cash flows at times m
    (length(cf) != length(m)) && error("BondPrice3: cf and m must have the same lengths")
    cdisc = cf./((1.0.+Y).^m)            #cf1/(1+Y1)^m1, cf2/(1+Y2)^m2 + ...
    P     = sum(cdisc)                   #price
    return P
end
