from attrs import define, asdict
import numpy as np

from tsunami.bin.tsunami_fort import run_solver as c_run_solver

@define
class SimParams:
    icenter: int
    grid_size: int
    timesteps: int
    dt: float
    dx: float
    c: float
    decay: float

def run_solver(sim_params: SimParams) -> np.ndarray:
    return c_run_solver(sim_params)