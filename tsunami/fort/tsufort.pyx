import numpy as np
from numpy cimport ndarray

cdef extern from 'tsufort.h':
    # cdef struct c_SimParams:
    #     int icenter
    #     int grid_size
    #     int timesteps
    #     double dt
    #     double dx
    #     double c
    #     double decay
        
    # cdef void c_run_solver(c_SimParams *word, double *h)
    # cdef bint test = True
    cdef bint f_validate_sim_params(int *grid_size, double *dt, double *dx, double *c)
    cdef double f_finite_diff_center(double *x, double *dx, int *n)
    cdef double f_gauss_init(int *grid_size, double *decay, int *icenter, double *h)
    cdef double f_update_water_height(double *h, double *u, double *dx, double *dt, int *grid_size)
    cdef double f_update_water_velocity(double *h, double *u, double *dx, double *dt, int *grid_size)

    # cdef void c_run_solver(int *icenter, int *grid_size, int *timesteps, double *dt, double *dx, double *c, double *decay, double *h)

#// cdef class c_Tsunami:
#    def run_solver(self, int icenter, int grid_size, int timesteps, double dt, double dx, double c, double decay):
#        cdef ndarray[dtype='double', ndim=2, mode='fortran'] h = np.empty((grid_size, timesteps + 1), dtype='double', order='F')
#        cdef SimParams sim_params = SimParams(icenter, grid_size, timesteps, dt, dx, c, decay)
#        c_run_solver(sim_params, &h[0, 0])
#        # c_run_solver(&icenter, &grid_size, &timesteps, &dt, &dx, &c, &decay, &h[0, 0])
#        return np.asfortranarray(h)

# def run_solver(sim_params):
#     cdef ndarray[dtype='double', ndim=2, mode='fortran'] h = np.empty((sim_params.grid_size, sim_params.timesteps + 1), dtype='double', order='F')
#     cdef c_SimParams c_sim_params
#     c_sim_params = c_SimParams(
#         sim_params.icenter, 
#         sim_params.grid_size, 
#         sim_params.timesteps, 
#         sim_params.dt, 
#         sim_params.dx, 
#         sim_params.c, 
#         sim_params.decay
#     )
#     # print(c_sim_params)
#     # exit()
#     c_run_solver(&c_sim_params, &h[0, 0])
# #     return np.asfortranarray(h)

def validate_sim_params(int grid_size, double dt, double dx, double c):
    '''
    Validate the tsunami simulation parameters.
    '''
    return f_validate_sim_params(&grid_size, &dt, &dx, &c)

def finite_diff_center(ndarray[dtype='double', ndim=1, mode='fortran'] x):
    '''
    Compute the first derivative numerically using the central finite difference scheme.
    '''
    cdef int n = x.shape[0]
    cdef ndarray[dtype='double', ndim=1, mode='fortran'] dx = np.empty(n, dtype='double', order='F')
    f_finite_diff_center(&x[0], &dx[0], &n)
    return dx

def gauss_init(int grid_size, double decay, int icenter):
    '''
    Initialize the simulation water height based on a Gauss shape.
    '''
    cdef ndarray[dtype='double', ndim=1, mode='fortran'] h = np.empty(grid_size, dtype='double', order='F')
    f_gauss_init(&grid_size, &decay, &icenter, &h[0])
    return h

def update_water_height(
    ndarray[dtype='double', ndim=1, mode='fortran'] h,
    ndarray[dtype='double', ndim=1, mode='fortran'] u,
    double dx,
    double dt,
):
    '''
    Update the water height using the shallow water equations.
    '''
    cdef int grid_size = h.shape[0]
    f_update_water_height(&h[0], &u[0], &dx, &dt, &grid_size)
    return h

def update_water_velocity(
    ndarray[dtype='double', ndim=1, mode='fortran'] h,
    ndarray[dtype='double', ndim=1, mode='fortran'] u,
    double dx,
    double dt,
):
    '''
    Update the water velocity using the shallow water equations.
    '''
    cdef int grid_size = h.shape[0]
    f_update_water_velocity(&h[0], &u[0], &dx, &dt, &grid_size)
    return u
