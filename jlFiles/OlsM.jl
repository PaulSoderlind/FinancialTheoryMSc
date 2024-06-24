"""
    OlsM(y,x)

Regress each of the `n` columns in `y` on the same set of `K` regressors in `x`.

### Input
- `y::VecOrMat`:     Txn, with n dependent variables
- `x::VecOrMat`:     TxK, with K regressors

### Output
- `b::Matrix`:        Kxn, regression coefficients
- `σ::Matrix`:        1xn, std(residuals)
"""
function OlsM(y,x)
    b = x\y             
    ϵ = y - x*b         #Txn, residuals
    σ = std(ϵ,dims=1)   
    return b,σ
end
