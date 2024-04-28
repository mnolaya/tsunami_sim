module fd_solver

    use, intrinsic :: iso_fortran_env, only: r64 => real64

    implicit none

    type :: SimParams
        integer :: icenter, grid_size, timesteps
        real(r64) :: dt, dx, c, decay
        contains
            procedure, pass :: validate => validate_sim_params
    end type SimParams

    interface SimParams
        module procedure init_sim_params
    end interface SimParams

    contains
        !> SimParams constructor
        function init_sim_params(icenter, grid_size, timesteps, dt, dx, c, decay) result(self)
            ! Args
            integer, intent(in) :: icenter, grid_size, timesteps
            real(r64), intent(in) :: dt, dx, c, decay
            type(SimParams) :: self

            self%icenter = icenter
            self%grid_size = grid_size
            self%timesteps = timesteps
            self%dt = dt
            self%dx = dx
            self%c = c
            self%decay = decay
        end function init_sim_params

        !> Validate params
        subroutine validate_sim_params(self)
            ! Args
            class(SimParams), intent(in) :: self

            if (self%grid_size <= 0) stop "grid_size must be > 0"
            if (self%dt <= 0) stop "time step dt must be > 0"
            if (self%dx <= 0) stop "grid spacing dx must be > 0"
            if (self%c <= 0) stop "background flow speed c must be > 0"
        end subroutine validate_sim_params

        !> Compute the finite difference between an array of points.
        function finite_diff(x) result(dx)
            ! Args
            real(r64), intent(in) :: x(:)
            real(r64) :: dx(size(x))

            ! Loc vars
            integer :: i

            i = size(x)
            dx(1) = x(1) - x(i) ! Periodic condition
            dx(2:i) = x(2:i) - x(1:i-1)
        end function finite_diff

        !> Run solver
        subroutine run_solver(sim_params, h)
            ! Args
            type(SimParams), intent(in) :: sim_params
            real(r64), allocatable, intent(out) :: h(:, :)

            ! Loc vars
            integer :: i, n
            real(r64), allocatable :: dh(:)

            allocate(h(sim_params%grid_size, sim_params%timesteps + 1))
            allocate(dh(sim_params%grid_size))

            ! Initialize water height at t = 0
            do concurrent (i = 1:sim_params%grid_size)
                h(i, 1) = exp(-sim_params%decay*(i - sim_params%icenter)**2)
            end do

            time_loop: do n = 1, sim_params%timesteps
                ! Update water height for timestep
                h(:, n + 1) = h(:, n) - (sim_params%c*finite_diff(h(:, n))/sim_params%dx)*sim_params%dt
            end do time_loop
        end subroutine run_solver
end module fd_solver

module py_iface

    use, intrinsic :: iso_fortran_env, only: r64 => real64
    use, intrinsic :: iso_c_binding, only: c_int, c_double
    use fd_solver, only: SimParams, run_solver

    implicit none

    contains
        subroutine c_run_solver(icenter, grid_size, timesteps, dt, dx, c, decay, h) bind(c)
            ! Args
            integer(c_int), intent(in) :: icenter, grid_size, timesteps
            real(c_double), intent(in) :: dt, dx, c, decay
            real(c_double), intent(out) :: h(grid_size, timesteps + 1)

            ! Loc vars
            real(r64), allocatable :: h_alloc(:, :)
            type(SimParams) :: sim_params

            ! Initialize SimParams type
            sim_params = SimParams(icenter, grid_size, timesteps, dt, dx, c, decay)

            ! Run solver
            call run_solver(sim_params, h_alloc)
            h = h_alloc
        end subroutine c_run_solver
end module py_iface

! program tsunami

!     use fd_solver, only: finite_diff

!     implicit none

!     integer, parameter :: icenter = 25
!     integer, parameter :: grid_size = 100, num_timesteps = 100
!     real, parameter :: dt = 1, dx = 1, c = 1, decay = 0.02

!     integer :: i, n
!     real :: h(grid_size), dh(grid_size)

!     if (grid_size <= 0) stop "grid_size must be > 0"
!     if (dt <= 0) stop "time step dt must be > 0"
!     if (dx <= 0) stop "grid spacing dx must be > 0"
!     if (c <= 0) stop "background flow speed c must be > 0"

!     ! Initialize water height at t = 0
!     do concurrent (i = 1:grid_size)
!         h(i) = exp(-decay*(i - icenter)**2)
!     end do
    
!     time_loop: do n = 1, num_timesteps
!         ! Update water height for timestep
!         h = h - (c*finite_diff(h)/dx)*dt

!         print *, n, h
!     end do time_loop
! end program tsunami