module fd_solver

    implicit none

    contains
        !> Compute the finite difference between an array of points.
        function finite_diff(x) result(dx)
            ! Args
            real, intent(in) :: x(:)
            real :: dx(size(x))

            ! Loc vars
            integer :: i

            i = size(x)
            dx(1) = x(1) - x(i) ! Periodic condition
            dx(2:i) = x(2:i) - x(1:i-1)
        end function finite_diff
end module fd_solver

program tsunami

    use fd_solver, only: finite_diff

    implicit none

    integer, parameter :: icenter = 25
    integer, parameter :: grid_size = 100, num_timesteps = 100
    real, parameter :: dt = 1, dx = 1, c = 1, decay = 0.02

    integer :: i, n
    real :: h(grid_size), dh(grid_size)

    if (grid_size <= 0) stop "grid_size must be > 0"
    if (dt <= 0) stop "time step dt must be > 0"
    if (dx <= 0) stop "grid spacing dx must be > 0"
    if (c <= 0) stop "background flow speed c must be > 0"

    ! Initialize water height at t = 0
    do concurrent (i = 1:grid_size)
        h(i) = exp(-decay*(i - icenter)**2)
    end do
    
    time_loop: do n = 1, num_timesteps
        ! Update water height for timestep
        h = h - (c*finite_diff(h)/dx)*dt

        print *, n, h
    end do time_loop
end program tsunami