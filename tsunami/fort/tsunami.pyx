import numpy as np
from numpy cimport ndarray

cdef extern from 'tsunami.h':
    cdef void c_run_solver(int *icenter, int *grid_size, int *timesteps, double *dt, double *dx, double *c, double *decay, double *h)

cdef class Tsunami:
    def run_solver(self, int icenter, int grid_size, int timesteps, double dt, double dx, double c, double decay):
        cdef ndarray[dtype='double', ndim=2, mode='fortran'] h = np.empty((grid_size, timesteps + 1), dtype='double', order='F')
        c_run_solver(&icenter, &grid_size, &timesteps, &dt, &dx, &c, &decay, &h[0, 0])
        return np.asfortranarray(h)