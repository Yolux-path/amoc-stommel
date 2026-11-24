module mod_solver
    
    use fonctions

    implicit none

contains

    subroutine step_EE(T, S, dt)
        real(8), intent(inout) :: T, S
        real(8), intent(in)    :: dt
        T = T + compute_dT(T) * dt
        S = S + compute_dS(S) * dt
    end subroutine

    subroutine step_EI(T, S, dt)
        real(8), intent(inout) :: T, S
        real(8), intent(in)    :: dt
        T = (T + dt * (T_star/tau_T + q*T_in)) / (1.0d0 + dt*(1.0d0/tau_T + q))
        S = (S + dt * (S_star/tau_S + q*S_in)) / (1.0d0 + dt*(1.0d0/tau_S + q))
    end subroutine


    subroutine step_Heun(T, S, dt)
        real(8), intent(inout) :: T, S
        real(8), intent(in)    :: dt
        real(8) :: T_pred, S_pred
        
        T_pred = T + compute_dT(T) * dt
        S_pred = S + compute_dS(S) * dt
        
        T = T + 0.5d0 * dt * (compute_dT(T) + compute_dT(T_pred))
        S = S + 0.5d0 * dt * (compute_dS(S) + compute_dS(S_pred))
    end subroutine

    
    subroutine step_CN(T, S, dt)
        real(8), intent(inout) :: T, S
        real(8), intent(in)    :: dt
        real(8) :: rhs_T, rhs_S
        
        
        rhs_T = T + 0.5d0 * dt * ( (T_star - T)/tau_T + q*(T_in - T) ) + 0.5d0 * dt * (T_star/tau_T + q*T_in)
        T = rhs_T / (1.0d0 + 0.5d0 * dt * (1.0d0/tau_T + q))
        
        rhs_S = S + 0.5d0 * dt * ( (S_star - S)/tau_S + q*(S_in - S) ) + 0.5d0 * dt * (S_star/tau_S + q*S_in)
        S = rhs_S / (1.0d0 + 0.5d0 * dt * (1.0d0/tau_S + q))
    end subroutine

    
    subroutine step_RK4(T, S, dt)
        real(8), intent(inout) :: T, S
        real(8), intent(in)    :: dt
        real(8) :: k1T, k2T, k3T, k4T, k1S, k2S, k3S, k4S

        k1T = compute_dT(T)
        k1S = compute_dS(S)

        k2T = compute_dT(T + 0.5d0*dt*k1T)
        k2S = compute_dS(S + 0.5d0*dt*k1S)

        k3T = compute_dT(T + 0.5d0*dt*k2T)
        k3S = compute_dS(S + 0.5d0*dt*k2S)

        k4T = compute_dT(T + dt*k3T)
        k4S = compute_dS(S + dt*k3S)

        T = T + (dt/6.0d0) * (k1T + 2.0d0*k2T + 2.0d0*k3T + k4T)
        S = S + (dt/6.0d0) * (k1S + 2.0d0*k2S + 2.0d0*k3S + k4S)
    end subroutine

end module