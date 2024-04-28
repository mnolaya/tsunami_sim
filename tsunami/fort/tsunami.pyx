cdef extern from "tsunami.h":
    cdef void c_run_solver(int *icenter, int *grid_size, int *timesteps, float *dt, float *dx, float *c, float *decay)

cdef class Tsunami:
    def run_solver(self, int icenter, int grid_size, int timesteps, float dt, float dx, float c, float decay):
        c_run_solver(&icenter, &grid_size, &timesteps, &dt, &dx, &c, &decay)