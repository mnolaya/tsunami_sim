program tsunami

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
        ! Calculate spatial changes in water height
        dh(1) = h(1) - h(grid_size) ! Periodic condition
        do concurrent (i = 2:grid_size)
            dh(i) = h(i) - h(i - 1)
        end do

        ! Update water height for timestep
        do concurrent (i = 1:grid_size)
            h(i) = h(i) - (c*dh(i)/dx)*dt
        end do

        print *, n, h
    end do time_loop
end program tsunami