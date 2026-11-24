module fonctions
    use donnees
    implicit none

    contains

    function sol_exacte_T(t, T0) result(Te)
        real(PR), intent(in) :: t, T0
        real(PR) :: Te, B
        B = (1.0_PR/tau_T + q)
        Te = T_inf + (T0 - T_inf) * exp(-B * t)
    end function

    function sol_exacte_S(t, S0) result(Se)
        real(PR), intent(in) :: t, S0
        real(PR)            :: Se, B_s
        
        B_s = (1.0_PR/tau_S + q)
        Se = S_inf + (S0 - S_inf) * exp(-B_s * t)

    end function sol_exacte_S

    ! Modèle simplifié (Equation 10)
    function flux_T_simplifie(T, T_star, eps, tau_s) result(dTdt)
        real(PR), intent(in) :: T, T_star, eps, tau_s
        real(PR) :: dTdt
        ! dT/dt = (1 / (eps * tau_s)) * (T_star - T)
        dTdt = (1.0_PR / (eps * tau_s)) * (T_star - T)
    end function
    
    function flux_S_simplifie(S, S_star, tau_s) result(dSdt)
        real(PR), intent(in) :: S, S_star, tau_s
        real(PR) :: dSdt
        ! dS/dt = (1 / tau_s) * (S_star - S)
        dSdt = (1.0_PR / tau_s) * (S_star - S)
    end function

    function compute_dT(T) result(dT)
        real(PR), intent(in) :: T
        real(PR) :: dT
        dT = (T_star - T) / tau_T + q * (T_in - T)
    end function

    function compute_dS(S) result(dS)
        real(PR), intent(in) :: S
        real(PR) :: dS
        dS = (S_star - S) / tau_S + q * (S_in - S)
    end function
    
end module fonctions