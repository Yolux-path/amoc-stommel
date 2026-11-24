module donnes
    implicit none
    integer, parameter :: PR = 8 
    
    ! Variables physiques
    real(PR) :: S_star1, S_star2, T_star1, T_star2
    real(PR) :: T_10, S_10, dt, tau_T, tau_S, q
    real(PR) :: alpha, beta ! Indispensables pour le flux
    
    ! Tableaux et temps
    real(PR), dimension(:), allocatable :: S_tab, T_tab, tab_q
    integer :: n_pts  
end module donnes