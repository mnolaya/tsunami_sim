from attrs import define
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

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
    l = ax.plot(xdata, h, label='t = 0 sec')[0]
    anno = ax.annotate(f't = {0:.3f} sec', xy=(0.98, 0.95), xycoords='axes fraction', ha='right')
    ax.set_xlabel('Distance [m]')
    ax.set_ylabel('Water height [m]')

    # Create array of time point indices to plot at
    ti_plot = np.linspace(0, sim_params.num_tsteps, NPLOT + 1, dtype=int)

    # Run sim
    u = np.zeros((sim_params.grid_size,))
    results = {'u': [u], 'h': [h], 't': [0]}
    for i in range(sim_params.num_tsteps):
        u = tsufort.update_water_velocity(h, u, sim_params.dx, sim_params.dt)
        h = tsufort.update_water_height(h, u, sim_params.dx, sim_params.dt)

        # Store results
        results['u'].append(u)
        results['h'].append(h)
        results['t'].append(sim_params.dt*(i + 1))

    def animate_time_series(frame, line, anno, data, time):
        anno.set_text(f't = {time[frame]:.3f} sec')
        line.set_ydata(data[frame])
        return [anno, line]
    
    ani = animation.FuncAnimation(fig, func=animate_time_series, frames=len(results['h'])-1, fargs=[l, anno, results['h'], results['t']], interval=5)
    plt.show()

    # print(results['h'][0])
    # print(results['h'][10])

if __name__ == "__main__":
    main()