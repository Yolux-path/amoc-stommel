module fonctions
    use donnes
    implicit none
contains

    function compute_dT(T, T_star) result(dT)
        real(PR), intent(in) :: T, T_star
        real(PR)             :: dT
        dT = (T_star - T) / tau_T - 2.0_PR * q * T
    end function compute_dT

    function compute_dS(S, S_star) result(dS)
        real(PR), intent(in) :: S, S_star
        real(PR)             :: dS
        dS = (S_star - S) / tau_S - 2.0_PR * q * S
    end function compute_dS
    
    function Q_flux(T, S) result(q_calc)
        real(PR), intent(in) :: S, T 
        real(PR)             :: q_calc
        ! LE PLUS IMPORTANT : L'équation physique avec alpha et beta
        q_calc = (alpha * T - beta * S)**2
    end function Q_flux 

    function evol_T_star(k) result(T_star)
        integer, intent(in) :: k 
        real(PR)            :: T_star
        ! La température reste constante dans ce scénario
        T_star = T_star1 
    end function evol_T_star

    function evol_S_star(k) result(S_star)
        integer, intent(in) :: k 
        real(PR)            :: S_star
        real(PR)            :: ratio
        
        if (k <= n_pts / 2) then
            ratio = real(k, PR) / real(n_pts / 2, PR)
        else
            ratio = real(n_pts - k, PR) / real(n_pts / 2, PR)
        end if
        S_star = S_star1 + ratio * (S_star2 - S_star1)
    end function evol_S_star

end module fonctions