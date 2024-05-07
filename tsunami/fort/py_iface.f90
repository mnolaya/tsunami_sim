module py_iface

    use, intrinsic :: iso_fortran_env, only: r64 => real64
    use, intrinsic :: iso_c_binding, only: c_int, c_double, c_ptr, c_f_pointer
    use fd_solver, only: SimParams, run_solver

    implicit none

    type, bind(c) :: c_SimParams
        integer(c_int) :: icenter, grid_size, timesteps
        real(c_double) :: dt, dx, c, decay
    end type c_SimParams

    contains
        subroutine c_run_solver(c_sim_params, h) bind(c)
        ! subroutine c_run_solver(icenter, grid_size, timesteps, dt, dx, c, decay, h) bind(c)
            ! Args
            ! type(c_SimParams), intent(in) :: c_sim_params
            type(c_ptr), intent(in) :: c_sim_params
            ! integer(c_int), intent(in) :: icenter, grid_size, timesteps
            ! real(c_double), intent(in) :: dt, dx, c, decay
            real(c_double), intent(out) :: h(100, 1000 + 1)
            
            ! Loc vars
            real(r64), allocatable :: h_alloc(:, :)
            type(SimParams), pointer :: sim_params

            call c_f_pointer(c_sim_params, sim_params)

            ! Initialize SimParams type
            ! c_sim_params = c_SimParams(icenter, grid_size, timesteps, dt, dx, c, decay)
            ! sim_params%icenter = c_sim_params%icenter
            ! sim_params%grid_size = c_sim_params%grid_size
            ! sim_params%timesteps = c_sim_params%timesteps
            ! sim_params%dt = c_sim_params%dt
            ! sim_params%dx = c_sim_params%dx
            ! sim_params%c = c_sim_params%c
            ! sim_params%decay = c_sim_params%decay
            ! sim_params = SimParams(icenter, grid_size, timesteps, dt, dx, c, decay)
            print *, sim_params%icenter
            print *, "check"
            call exit()

            ! Run solver and copy data to explicitly sized array for interfacing with C
            call run_solver(sim_params, h_alloc)
            h = h_alloc
        end subroutine c_run_solver

        ! subroutine alloc_simdata(ptr) bind(c)
        !     type(c_ptr), intent(out) :: ptr
        !     type

        ! end subroutine alloc_simdata
end module py_iface