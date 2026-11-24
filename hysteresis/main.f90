program main
    use donnes
    use fonctions 
    use schemas
    implicit none
    integer         :: i , choix_schema
    real(PR)        :: S , T , T_star , S_star


! --- PARAMÈTRES PHYSIQUES (adimensionnés) ---
alpha = 1.0_PR
beta  = 1.0_PR
tau_T = 0.01_PR
tau_S = 3.0_PR    ! Reste bien au-dessus de 1.5

! --- FORÇAGES ---
T_star1 = 1.0_PR  ! Fixe
T_star2 = 1.0_PR
S_star1 = 0.5_PR  ! Point de départ du cycle
S_star2 = 1.5_PR  ! Fin du balayage aller

! --- TEMPS (Quasi-statique) ---
dt = 0.001_PR
n_pts = 200000    ! Vitesse de balayage : plus n_pts est grand, plus les bascules sont proches de la théorie

! --- CONDITIONS INITIALES ---
T_10 = 1.0_PR
S_10 = 0.1_PR     ! Proche de l'équilibre de départ pour éviter un saut énorme
q = Q_flux(T_10, S_10)


    choix_schema = 3


    allocate(S_tab(n_pts), T_tab(n_pts), tab_q(n_pts))
    
    ! Initialisation
    S_tab(1) = S_10
    T_tab(1) = T_10
    T_star = evol_T_star(0)
    S_star = evol_S_star(0)

    do i = 1 , n_pts-1 
        S = S_tab(i)
        T = T_tab(i)
        q = Q_flux(T_tab(i),S_tab(i))
        tab_q(i) = q
        select case (choix_schema)
            case (1)
                call step_EE(T, S, dt, T_star,S_star)
            case (2)
                call step_Heun(T, S, dt, T_star,S_star)
            case (3)
                call step_RK4(T, S, dt, T_star,S_star)
        end select
        S_tab(i+1) = S
        T_tab(i+1) = T
        T_star = evol_T_star(i)
        S_star = evol_S_star(i)
    end do 
    tab_q(n_pts) = Q_flux(T_tab(n_pts), S_tab(n_pts))

    open(unit=1, file="valeurs.dat", status="replace")
    do i = 1, n_pts, 100
        write(1,*) i*dt , tab_q(i) , S_tab(i) , T_tab(i) , evol_T_star(i), evol_S_star(i)  
    end do 
    close(1)



    
end program main