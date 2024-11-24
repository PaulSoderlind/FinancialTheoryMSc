"""
    MVCalc(μˣ,μ,Σ)

Calculate the std and weights of a portfolio (with mean return μˣ) on MVF of risky assets.

"""
function MVCalc(μˣ,μ,Σ) #the std of a portfolio on MVF of risky assets
    n    = length(μ)
    A     = [Σ        μ ones(n);   #A is just a name of this matrix, it's not asset A
             μ'       0 0;
             ones(n)' 0 0];
    wλδ   = A\[zeros(n);μˣ;1]
    w     = wλδ[1:n]
    StdRp = sqrt(w'Σ*w)
    return StdRp,w
end


"""
    MVCalcRf(μˣ,μ,Σ,Rf)

Calculate the std and portfolio weights of a portfolio (with a given mean, μˣ) on MVF of (risky assets,riskfree)
"""
function MVCalcRf(μˣ,μ,Σ,Rf)
    μᵉ    = μ .- Rf                 #expected excess returns
    Σ_1   = inv(Σ)
    w     = (μˣ-Rf)/(μᵉ'Σ_1*μᵉ) * Σ_1*μᵉ
    StdRp = sqrt(w'Σ*w)
    return StdRp,w
end


"""
    MVTangencyP(μ,Σ,Rf)

Calculate the tangency portfolio
"""
function MVTangencyP(μ,Σ,Rf)           #calculates the tangency portfolio
    n     = length(μ)
    μᵉ    = μ .- Rf                    #expected excess returns
    Σ_1   = inv(Σ)
    w     = Σ_1 *μᵉ/(ones(n)'Σ_1*μᵉ)
    muT   = w'μ + (1-sum(w))*Rf
    StdT  = sqrt(w'Σ*w)
    return w,muT,StdT
end
