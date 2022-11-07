func reduce(φ1, φ2, τ: float64): float64 =
    ## Reduces two surface into one using Gaussian reduction
    ## φ1, φ2: power of surface 1 and 2, respectively
    ## τ: index adjusted distance from surface 1 to surface 2
    ##    τ = t/n
    ## returns: power of the reduced surface
    result = φ1 + φ2 - τ*φ1*φ2
