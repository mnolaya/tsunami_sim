import numpy as np
from numpy cimport ndarray

#// from tsunami.py.tsunami_solver import SimParams

cdef extern from 'tsunami_fort.h':
    cdef struct c_SimParams:
        int icenter
        int grid_size
        int timesteps
        double dt
        double dx
        double c
        double decay
        
    cdef void c_run_solver(c_SimParams, double *h)
    # cdef void c_run_solver(int *icenter, int *grid_size, int *timesteps, double *dt, double *dx, double *c, double *decay, double *h)

#// cdef class c_Tsunami:
#    def run_solver(self, int icenter, int grid_size, int timesteps, double dt, double dx, double c, double decay):
#        cdef ndarray[dtype='double', ndim=2, mode='fortran'] h = np.empty((grid_size, timesteps + 1), dtype='double', order='F')
#        cdef SimParams sim_params = SimParams(icenter, grid_size, timesteps, dt, dx, c, decay)
#        c_run_solver(sim_params, &h[0, 0])
#        # c_run_solver(&icenter, &grid_size, &timesteps, &dt, &dx, &c, &decay, &h[0, 0])
#        return np.asfortranarray(h)

def run_solver(sim_params):
    cdef ndarray[dtype='double', ndim=2, mode='fortran'] h = np.empty((sim_params.grid_size, sim_params.timesteps + 1), dtype='double', order='F')
    c_sim_params = c_SimParams(
        sim_params.icenter, 
        sim_params.grid_size, 
        sim_params.timesteps, 
        sim_params.dt, 
        sim_params.dx, 
        sim_params.c, 
        sim_params.decay
    )
    c_run_solver(c_sim_params, &h[0, 0])
    return np.asfortranarray(h)