"""
    MVCalc(μstar,μ,Σ)

Calculate the std and weights of a portfolio (with mean return μstar) on MVF of risky assets.

# Remark
- Only (λ,δ) and thus (w,stdRp) depend on μstar. We could therefore speed up the computations a bit
by doing the loop over different μstar values inside the function (and thus not recalculate Σ_1,a,b,c).
"""
function MVCalc(μstar,μ,Σ)
    n    = length(μ)
    Σ_1  = inv(Σ)
    a    = μ'Σ_1*μ
    b    = μ'Σ_1*ones(n)
    c    = ones(n)'Σ_1*ones(n)
    λ    = (c*μstar - b)/(a*c-b^2)
    δ    = (a-b*μstar)/(a*c-b^2)
    w    = Σ_1 *(μ*λ.+δ)
    StdRp = sqrt(w'Σ*w)
    return StdRp,w
end


"""
    MVCalcRf(μstar,μ,Σ,Rf)

Calculate the std and portfolio weights of a portfolio (with a given mean, μstar) on MVF of (risky assets,riskfree)
"""
function MVCalcRf(μstar,μ,Σ,Rf)
    μe    = μ .- Rf
    Σ_1   = inv(Σ)
    w     = (μstar-Rf)/(μe'Σ_1*μe) * Σ_1*μe
    StdRp = sqrt(w'Σ*w)
    return StdRp,w                    #std and portfolio weights
end


"""
    MVTangencyP(μ,Σ,Rf)

Calculate the tangency portfolio
"""
function MVTangencyP(μ,Σ,Rf)           #calculates the tangency portfolio
    n    = length(μ)
    μe   = μ .- Rf                    #expected excess returns
    Σ_1  = inv(Σ)
    w    = Σ_1 *μe/(ones(n)'Σ_1*μe)
    muT  = w'μ + (1-sum(w))*Rf
    StdT = sqrt(w'Σ*w)
    return w,muT,StdT                  #portolio weights, mean and std
end
