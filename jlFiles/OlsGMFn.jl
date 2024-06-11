#------------------------------------------------------------------------------
"""
    OlsGMFn(Y,X)

LS of Y on X; for one dependent variable, Gauss-Markov assumptions

# Usage
(b,u,Yhat,V,R2) = OlsGMFn(Y,X)

# Input
- `Y::Vector`:    T-vector, the dependent variable
- `X::Matrix`:    Txk matrix of regressors (including deterministic ones)

# Output
- `b::Vector`:    k-vector, regression coefficients
- `u::Vector`:    T-vector, residuals Y - yhat
- `Yhat::Vector`: T-vector, fitted values X*b
- `V::Matrix`:    kxk matrix, covariance matrix of b
- `R2::Number`:   scalar, R2 value

"""
function OlsGMFn(Y,X)

    T    = size(Y,1)

    b    = X\Y
    Yhat = X*b
    u    = Y - Yhat

    σ2   = var(u)
    V    = inv(X'X)*σ2
    R2   = 1 - σ2/var(Y)

    return b, u, Yhat, V, R2

end
#------------------------------------------------------------------------------
