#------------------------------------------------------------------------------
"""
    OlsGMFn(Y,X)

LS of Y on X; for one dependent variable, Gauss-Markov assumptions

# Usage
(b,u,Yhat,V,R2) = OlsGMFn(Y,X)

# Input
- `Y::Vector`:    Tx1, the dependent variable
- `X::Matrix`:    Txk matrix of regressors (including deterministic ones)

# Output
- `b::Vector`:    kx1, regression coefficients
- `u::Vector`:    Tx1, residuals Y - yhat
- `Yhat::Vector`: Tx1, fitted values X*b
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
    R2  = 1 - σ2/var(Y)

    return b, u, Yhat, V, R2

end
#------------------------------------------------------------------------------
