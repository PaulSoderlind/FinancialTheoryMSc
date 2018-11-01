
function MVCalc(mustar,μ,Σ) #the std of a portfolio on MVF of risky assets
    n    = length(μ)
    oneV = ones(n)
    Σ_1  = inv(Σ)
    A    = μ'Σ_1*μ
    B    = μ'Σ_1*oneV
    C    = oneV'Σ_1*oneV
    λ    = (C*mustar - B)/(A*C-B^2)
    δ    = (A-B*mustar)/(A*C-B^2)
    w    = Σ_1 *(μ*λ.+δ)
    StdRp = sqrt(w'Σ*w)
    return StdRp,w
end

function MVCalcRf(mustar,μ,Σ,Rf)           #calculates the std of a portfolio
    n     = length(μ)                      #on MVF of (Risky,Riskfree)
    μe    = μ .- Rf                        #expected excess returns
    Σ_1   = inv(Σ)
    w     = (mustar-Rf)/(μe'Σ_1*μe) * Σ_1*μe
    StdRp = sqrt(w'Σ*w)
    return StdRp,w
end

function MVTangencyP(μ,Σ,Rf)           #calculates the tangency portfolio
    n     = length(μ)
    oneV  = ones(n)
    μe    = μ .- Rf                    #expected excess returns
    Σ_1   = inv(Σ)
    w     = Σ_1 *μe/(oneV'Σ_1*μe)
    muT   = w'μ + (1-sum(w))*Rf
    StdT = sqrt(w'Σ*w)
    return w,muT,StdT
end
