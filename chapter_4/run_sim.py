from attrs import define
import numpy as np

from tsunami.fort import tsufort

@define
class SimParams:
    grid_size: int = 100
    num_tsteps: int = 100
    dt: float = 1.0
    dx: float = 1.0
    c: float = 1.0

def main() -> None:
    # Set simulation parameters
    sim_params = SimParams()
    print(sim_params)
    # Check parameters are okay for simulation
    is_valid = tsufort.validate_sim_params(sim_params.grid_size, sim_params.dt, sim_params.dx, sim_params.c)
    print(is_valid)
    x = np.array([0, 1, 2, 1, 2, 3], dtype=float)
    print(x)
    dx = tsufort.finite_diff_center(x)
    print(dx)
    

if __name__ == "__main__":
    main()