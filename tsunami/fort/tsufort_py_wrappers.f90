module tsufort_py_wrappers

    use, intrinsic :: iso_fortran_env, only: r64 => real64
    use, intrinsic :: iso_c_binding, only: c_int, c_double, c_bool
    use tsufort, only: validate_sim_params, finite_diff_center

    implicit none

    contains
        ! Validate simulation parameters
        function f_validate_sim_params( &
            grid_size, &
            dt, &
            dx, &
            c &
        ) result(is_valid) bind(c)
            ! Args
            integer(c_int), intent(in) :: grid_size
            real(c_double), intent(in) :: dt, dx, c
            logical(c_bool) :: is_valid

            is_valid = validate_sim_params(grid_size, dt, dx, c)
        end function f_validate_sim_params

        ! Finite difference central difference scheme
        subroutine f_finite_diff_center(x, dx, n) bind(c)
            ! Args
            integer(c_int), intent(in) :: n
            real(c_double), intent(in) :: x(n)
            real(c_double), intent(out) :: dx(n)

            ! Loc vars
            real(r64), allocatable :: x_(:)

            allocate(x_, source=x)
            dx = finite_diff_center(x_)
        end subroutine f_finite_diff_center
end module tsufort_py_wrappers