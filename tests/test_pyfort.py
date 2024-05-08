import numpy as np
# import matplotlib.pyplot as plt

from tsunami.py import tsunami_solver as solver

SIM_PARAMS = {
    'icenter': 25,
    'dx': 1,
    'dt': 0.02,
    'c': 1,
    'decay': 0.02,
    'grid_size': 100,
    'timesteps': 1000
}

def curve(decay, icenter, grid_size, **kwargs) -> np.ndarray:
    return [np.exp(-decay*(i+1 - icenter)**2) for i in range(grid_size)]

sim_params = solver.SimParams(**SIM_PARAMS)
h = solver.run_solver(sim_params)
print(h)
# solver = tsunami_fort.Tsunami()
# h = solver.run_solver(**SIM_PARAMS)