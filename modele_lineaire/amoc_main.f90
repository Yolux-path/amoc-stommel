program amoc_simulation
    use donnees
    use mod_solver
    use post_traitement
    implicit none

    real(PR), allocatable :: tab_dt(:), err_T(:), err_S(:)
    real(PR) :: T, S, dt_j, t_curr
    integer  :: i, j, n_steps_j
    character(len=60) :: nom_f

    ! Initialisation : lecture de parametres.dat et calcul de T_inf, S_inf
    call Initialisation()

    ! Allocation pour l'étude de convergence
    allocate(tab_dt(0:n_raf), err_T(0:n_raf), err_S(0:n_raf))

    print*, "--- Lancement de la simulation AMOC : Modele de base ---"

    do j = 0, n_raf
        ! Raffinement du pas de temps
        call raffinement(j, dt_j, n_steps_j)
        tab_dt(j) = dt_j
     
        ! Conditions initiales (T0=10, S0=33)
        T = 10.0_PR ; S = 33.0_PR ; t_curr = 0.0_PR

        ! Fichier de sortie spécifique au raffinement j
        write(nom_f, '(A, I1, A)') "sol_raf_", j, ".dat"
        open(unit=20, file=trim(nom_f), status="replace")
        
        write(20, '(A, F12.4, A, F12.4, A, I2)') "# T_inf ", T_inf, " S_inf ", S_inf, " Schema: ", choix_schema

        do i = 1, n_steps_j
            ! Écriture : Temps, Température, Salinité, Erreur absolue
            write(20, '(4F15.8)') t_curr, T, S, abs(T - T_inf)

            select case (choix_schema)
            case (1)
                call step_EE(T, S, dt_j)
            case (2)
                call step_EI(T, S, dt_j)
            case (3)
                call step_Heun(T, S, dt_j)
            case (4)
                call step_CN(T, S, dt_j)
            case (5)
                call step_RK4(T, S, dt_j)
            case default
                stop "choix_schema inconnu (1: EE, 2: EI, 3: Heun, 4: CN, 5: RK4)"
            end select
            
            t_curr = t_curr + dt_j
        end do 
        close(20)

        ! Calcul de l'erreur globale pour le graphique de convergence
        call Calcul_erreurs(err_T(j), err_S(j), T, S, t_curr)
    end do

    ! Écriture du fichier final erreurs.dat (log-log)
    call ecrit_erreurs(tab_dt, err_T, err_S)

    deallocate(tab_dt, err_T, err_S)
    call Fin()

end program amoc_simulation