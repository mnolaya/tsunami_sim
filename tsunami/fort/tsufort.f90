module tsufort

    use, intrinsic :: iso_fortran_env, only: r64 => real64

    implicit none
    private
    public :: validate_sim_params, &
        finite_diff_center, &
        gauss_init, &
        update_water_height, &
        update_water_velocity

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
        ) result(is_valid)
            ! Args
            integer, intent(in) :: grid_size
            real(r64), intent(in) :: dt, dx, c
            logical :: is_valid
            
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

        !> Initialize water height with Gaussian curve shape
        function gauss_init(grid_size, decay, icenter) result(h)
            ! Args
            integer, intent(in) :: grid_size, icenter
            real(r64), intent(in) :: decay
            real(r64) :: h(grid_size)

            ! Loc vars
            integer :: i

            do concurrent (i = 1:grid_size)
                h(i) = exp(-decay*(i - icenter)**2)
            end do
        end function gauss_init

        !> Update the water velocity for the next timestep using the shallow water equations
        !> du/dt + u*grad(u) = -g*grad(h)
        subroutine update_water_velocity(h, u, dx, dt)
            ! Args
            real(r64), intent(in) :: h(:), dx, dt
            real(r64), intent(inout) :: u(:)

            ! Loc vars
            real(r64), parameter :: g = 9.81

            u = u - ((u*finite_diff_center(u) + g*finite_diff_center(h))/dx)*dt
        end subroutine update_water_velocity

        !> Update the water height for the next timestep using the shallow water equations
        !> dh/dt = -grad(u*(H + h))
        subroutine update_water_height(h, u, dx, dt)
            ! Args
            real(r64), intent(in) :: u(:), dx, dt
            real(r64), intent(inout) :: h(:)

            ! Loc vars
            real(r64), parameter :: hmean = 10, g = 9.81

            h = h - (finite_diff_center(u*(hmean + h))/dx)*dt
        end subroutine update_water_height

        ! subroutine run_simulation()

        ! end subroutine run_simulation
end module tsufort