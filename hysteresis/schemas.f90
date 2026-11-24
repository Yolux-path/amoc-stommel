module schemas
    use donnes 
    use fonctions 

    implicit none
    
contains


    subroutine step_EE( T, S, dt, T_star,S_star)
        real(8), intent(inout) ::  T,  T_star, S, S_star
        real(8), intent(in)    :: dt
        T = T + compute_dT(T,  T_star) * dt
        S = S + compute_dS(S,  S_star) * dt
    end subroutine


    subroutine step_Heun(T, S, dt, T_star,S_star)
        real(8), intent(inout) :: T, S
        real(8), intent(in)    :: dt, T_star, S_star
        real(8) :: T_pred, S_pred, k1T, k1S
        
        T_pred = T + compute_dT(T,T_star) * dt
        S_pred = S + compute_dS(S,S_star) * dt
        
        ! q dépend de T et S : il est réévalué à chaque étage
        k1T = compute_dT(T, T_star)
        k1S = compute_dS(S, S_star)
        q = Q_flux(T_pred, S_pred)
        T = T + 0.5d0 * dt * (k1T + compute_dT(T_pred, T_star))
        S = S + 0.5d0 * dt * (k1S + compute_dS(S_pred, S_star))
    end subroutine

    
    subroutine step_RK4(T, S, dt, T_star,S_star)
        real(8), intent(inout) :: T, S
        real(8), intent(in)    :: dt, T_star, S_star
        real(8) :: k1T, k2T, k3T, k4T, k1S, k2S, k3S, k4S

        k1T = compute_dT(T, T_star)
        k1S = compute_dS(S, S_star)

        ! q dépend de T et S : il est réévalué à chaque étage
        q = Q_flux(T + 0.5d0*dt*k1T, S + 0.5d0*dt*k1S)
        k2T = compute_dT(T + 0.5d0*dt*k1T, T_star)
        k2S = compute_dS(S + 0.5d0*dt*k1S, S_star)

        q = Q_flux(T + 0.5d0*dt*k2T, S + 0.5d0*dt*k2S)
        k3T = compute_dT(T + 0.5d0*dt*k2T, T_star)
        k3S = compute_dS(S + 0.5d0*dt*k2S, S_star)

        q = Q_flux(T + dt*k3T, S + dt*k3S)
        k4T = compute_dT(T + dt*k3T, T_star)
        k4S = compute_dS(S + dt*k3S, S_star)

        T = T + (dt/6.0d0) * (k1T + 2.0d0*k2T + 2.0d0*k3T + k4T)
        S = S + (dt/6.0d0) * (k1S + 2.0d0*k2S + 2.0d0*k3S + k4S)
    end subroutine

    
end module schemas