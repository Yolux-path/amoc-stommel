module donnees
    implicit none
    integer, parameter :: PR = 8

    ! Paramètres physiques et numériques
    real(PR) :: T_star, S_star, T_in, S_in, tau_T, tau_S, q, dt_init
    real(8)  :: T_inf, S_inf
    integer  :: n_steps_base, n_raf, choix_schema

    contains

    subroutine Initialisation()
        open(unit=10, file="parametres.dat", status="old", action="read")
        ! Lecture : T*, S*, Tin, Sin, tauT, tauS, q, dt_base, n_steps_base, n_raf, schema
        read(10,*) T_star, S_star, T_in, S_in, tau_T, tau_S, q, dt_init, n_steps_base, n_raf, choix_schema
        close(10)
        
        ! Calcul des asymptotes théoriques
        T_inf = (T_star + q * T_in * tau_T) / (tau_T * q + 1.0d0)
        S_inf = (S_star + q * S_in * tau_S) / (tau_S * q + 1.0d0)
    end subroutine Initialisation

    subroutine raffinement(j, current_dt, current_n)
        integer, intent(in) :: j
        real(PR), intent(out) :: current_dt
        integer, intent(out) :: current_n
        
        ! Le raffinement divise le pas de temps par 2^j et multiplie les itérations par 2^j
        current_dt = dt_init / (2.0_PR**j)
        current_n  = n_steps_base * (2**j)
    end subroutine raffinement

    subroutine Fin()
        print *, "Simulation terminée. Les résultats sont dans 'err.dat'."
    end subroutine Fin

end module donnees