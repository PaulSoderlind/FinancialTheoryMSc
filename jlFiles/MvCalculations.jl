"""
    MVCalc(μstar,μ,Σ)

Calculate the std and portfolio weights of a portfolio (with a given mean, μstar) on MVF of risky assets.

"""
function MVCalc(μstar,μ,Σ) #the std of a portfolio on MVF of risky assets
    n     = length(μ)
    Σ_1   = inv(Σ)
    A     = μ'Σ_1*μ
    B     = μ'Σ_1*ones(n)
    C     = ones(n)'Σ_1*ones(n)
    λ     = (C*μstar - B)/(A*C-B^2)
    δ     = (A-B*μstar)/(A*C-B^2)
    w     = Σ_1 *(μ*λ.+δ)
    StdRp = sqrt(w'Σ*w)
    return StdRp,w                    #std and portfolio weights
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
