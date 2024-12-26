from attrs import define
import numpy as np
import matplotlib.pyplot as plt

from tsunami.fort import tsufort

@define
class SimParams:
    grid_size: int = 100
    num_tsteps: int = 5000
    dt: float = 0.02
    dx: float = 1.0
    c: float = 1.0
    decay: float = 0.02
    icenter: int = 25

NPLOT = 4
def main() -> None:
    # Create figure for plotting
    fig, ax = plt.subplots()

    # Set simulation parameters
    sim_params = SimParams()

    # Check parameters are okay for simulation
    is_valid = tsufort.validate_sim_params(sim_params.grid_size, sim_params.dt, sim_params.dx, sim_params.c)
    if not is_valid:
        print('error: simulation parameters are not valid... terminating')
        exit()

    # Initialize the water height of the simulation
    h = tsufort.gauss_init(sim_params.grid_size, sim_params.decay, sim_params.icenter)

    # Add initial water height to plot
    xdata = np.arange(1, sim_params.grid_size + 1)
    ax.plot(xdata, h, label='t = 0 sec')

    # Create array of time point indices to plot at
    ti_plot = np.linspace(0, sim_params.num_tsteps, NPLOT + 1, dtype=int)

    # Run sim
    u = np.zeros((sim_params.grid_size,))
    for i in range(sim_params.num_tsteps):
        u = tsufort.update_water_velocity(h, u, sim_params.dx, sim_params.dt)
        h = tsufort.update_water_height(h, u, sim_params.dx, sim_params.dt)

        # Plot at specified time points
        t = i*sim_params.dt
        if not np.any(i + 1 == ti_plot): continue
        ax.plot(xdata, h, label=f't = {t:.2f} sec')

    # Style plot
    ax.legend()
    fig.tight_layout()
    plt.show()
    

if __name__ == "__main__":
    main()