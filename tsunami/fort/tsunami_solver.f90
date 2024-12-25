module fd_solver

    use, intrinsic :: iso_fortran_env, only: r64 => real64
    use, intrinsic :: iso_c_binding, only: c_bool, c_int, c_double

    implicit none

    type :: SimParams
        integer :: icenter, grid_size, timesteps
        real(r64) :: dt, dx, c, decay
        ! contains
        !     procedure, pass :: validate => validate_sim_params
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

        ! !> Validate params
        ! subroutine validate_sim_params(self)
        !     ! Args
        !     class(SimParams), intent(in) :: self

        !     if (self%grid_size <= 0) stop "grid_size must be > 0"
        !     if (self%dt <= 0) stop "time step dt must be > 0"
        !     if (self%dx <= 0) stop "grid spacing dx must be > 0"
        !     if (self%c <= 0) stop "background flow speed c must be > 0"
        ! end subroutine validate_sim_params

        ! Validate simulation parameters
        function validate_sim_params( &
            grid_size, &
            dt, &
            dx, &
            c &
        ) bind(c, name="f_validate_sim_params") result(is_valid)
            ! Args
            integer(c_int), intent(in) :: grid_size
            real(c_double), intent(in) :: dt, dx, c
            logical(c_bool) :: is_valid
            
            is_valid = .true.
            if (grid_size <= 0) then
                print *, "grid_size must be > 0"
                is_valid = .false.
            end if
            if (dt <= 0) then
                print *, "time step dt must be > 0"
                is_valid = .false.
            end if
            if (dx <= 0) then
                print *, "grid spacing dx must be > 0"
                is_valid = .false.
            end if
            if (c <= 0) then
                print *, "background flow speed c must be > 0"
                is_valid = .false.
            end if
        end function validate_sim_params

        !> Compute the finite difference between an array of points.
        function finite_diff_upwind(x) result(dx)
            ! Args
            real(r64), intent(in) :: x(:)
            real(r64) :: dx(size(x))

            ! Loc vars
            integer :: i

            i = size(x)
            dx(1) = x(1) - x(i) ! Periodic condition
            dx(2:i) = x(2:i) - x(1:i-1)
        end function finite_diff_upwind

        !> Compute the finite difference between an array of points.
        function finite_diff_center(x) result(dx)
            ! Args
            real(r64), intent(in) :: x(:)
            real(r64) :: dx(size(x))

            ! Loc vars
            integer :: i

            i = size(x)
            dx(1) = x(2) - x(i)  ! Periodic condition (left)
            dx(i) = x(1) - x(i - 1)  ! Periodic condition (right)
            dx(2:i-1) = x(3:i) - x(1:i-2)  ! Internal nodes
            dx = dx * 0.5_r64
        end function finite_diff_center

        !> Run solver
        subroutine run_solver(sim_params, h)
            ! Args
            type(SimParams), intent(in) :: sim_params
            real(r64), allocatable, intent(out) :: h(:, :)

            ! Loc vars
            real(r64), parameter :: hmean = 10, g = 9.81

            integer :: i, n
            real(r64), allocatable :: dh(:), u(:)

            allocate(h(sim_params%grid_size, sim_params%timesteps + 1))
            allocate(dh(sim_params%grid_size))
            allocate(u(sim_params%grid_size))

            ! Initialize water height and velocity at t = 0
            do concurrent (i = 1:sim_params%grid_size)
                h(i, 1) = exp(-sim_params%decay*(i - sim_params%icenter)**2)
            end do
            u = 0

            ! Update water height and velocity
            time_loop: do n = 1, sim_params%timesteps
                u = u - ((u*finite_diff_center(u) + g*finite_diff_center(h(:, n)))/sim_params%dx)*sim_params%dt
                h(:, n + 1) = h(:, n) - (finite_diff_center(u*(hmean + h(:, n)))/sim_params%dx)*sim_params%dt
            end do time_loop
        end subroutine run_solver
end module fd_solver