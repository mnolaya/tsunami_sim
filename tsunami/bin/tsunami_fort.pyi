import cython
import numpy as np

class Tsunami:
    def __init__(self):
        ...

    def run_solver(
        self,
        icenter: cython.int,
        grid_size: cython.int,
        timesteps: cython.int,
        dt: cython.double,
        dx: cython.double,
        c: cython.double,
        decay: cython.double
    ) -> np.ndarray:
        ...