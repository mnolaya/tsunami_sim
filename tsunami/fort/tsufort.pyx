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

# def finite_diff_center(ndarray[dtype='double', ndim=1, mode='fortran'] x):
def finite_diff_center(ndarray[dtype='double', ndim=1, mode='fortran'] x):
    '''
    Compute the first derivative numerically using the central finite difference scheme.
    '''
    cdef int n = x.shape[0]
    cdef ndarray[dtype='double', ndim=1, mode='fortran'] dx = np.empty(n, dtype='double', order='F')
    f_finite_diff_center(&x[0], &dx[0], &n)
    return dx