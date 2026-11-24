module post_traitement

    use fonctions
    use donnees

    implicit none

    contains

        ! Calcule l'erreur finale entre la simulation et l'asymptote théorique
        subroutine Calcul_erreurs(err_T, err_S, final_T, final_S, t)
            real(PR), intent(in)  :: final_T, final_S, t
            real(PR), intent(out) :: err_T, err_S
        ! On compare à la solution analytique au temps t, pas à l'asymptote
            err_T = abs(final_T - sol_exacte_T(t, 10.0_PR))
            err_S = abs(final_S - sol_exacte_S(t, 33.0_PR))
        
        end subroutine Calcul_erreurs

        ! Écrit les erreurs de convergence en fonction de dt (pour le tracé log-log)
        subroutine ecrit_erreurs(tab_dt, tab_err_T, tab_err_S)
            real(PR), dimension(:), intent(in) :: tab_dt
            real(PR), dimension(:), intent(in) :: tab_err_T, tab_err_S
            integer :: j

            open(unit=30, file="err.dat", action="write", status="replace")
            write(30, *) "# dt          Erreur_T          Erreur_S"

            do j = 1, size(tab_dt)
                write(30, '(3E15.8)') tab_dt(j), tab_err_T(j), tab_err_S(j)
            end do

            close(30)
        
        end subroutine ecrit_erreurs

end module post_traitement