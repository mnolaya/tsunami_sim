import numpy as np
import matplotlib.pyplot as plt

from tsunami.py import _env
import tsunami.bin.tsunami as tsunami_fort

SIM_PARAMS = {
    'icenter': 25,
    'dx': 1,
    'dt': 1,
    'c': 1,
    'decay': 0.02,
    'grid_size': 100,
    'timesteps': 100
}

def curve(decay, icenter, grid_size, **kwargs) -> np.ndarray:
    return [np.exp(-decay*(i+1 - icenter)**2) for i in range(grid_size)]

solver = tsunami_fort.Tsunami()
h = solver.run_solver(**SIM_PARAMS)