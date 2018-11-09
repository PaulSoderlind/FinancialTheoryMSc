"""
    BondPrice3(Y,cf,m)

Calculate bond price from cash flow stream

# Input
- `Y::scalar or K vector`:   interest rates
- `cf::scalar or K vector`:  cash flows
- `m::K vector`:             times of the cash flows
"""
function BondPrice3(Y,cf,m)           #cf is a vector of all cash flows at times m
    cdisc = cf./((Y.+1).^m)           #c/(1+y1)^m1, c/(1+y2)^m2 + ...
    P     = sum(cdisc)                #price
    return P
end
