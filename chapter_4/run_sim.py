from attrs import define

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

    # Check parameters are okay for simulation
    print(tsufort.validate_sim_params(sim_params.grid_size, sim_params.dt, sim_params.dx, sim_params.c))
        # print('check')


    print(sim_params)
    

if __name__ == "__main__":
    main()