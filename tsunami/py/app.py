from dash_extensions.enrich import DashProxy, Input, Output, State, TriggerTransform, Trigger, dcc, callback, MultiplexerTransform
import dash_bootstrap_components as dbc
import plotly.graph_objs as go
import numpy as np

# Load the shared object libraries for the tsunami simulator
# from tsunami.bin.tsunami_fort import Tsunami
from tsunami.py import tsunami_solver as solver

app = DashProxy(__name__, external_stylesheets=[dbc.themes.MATERIA], transforms=[TriggerTransform(), MultiplexerTransform()])

def plot_sim_results(h) -> go.Figure:
    xdata = [i+1 for i in range(h.shape[0])]
    fig = go.Figure(
        data=go.Scatter(x=xdata, y=h[:, 0]),
        layout=go.Layout(
            xaxis_title='x [m]',
            yaxis_title='water height [m]',
            updatemenus=[
                {
                    'type': 'buttons',
                    'buttons': [
                        {
                            'label': 'Play',
                            'method': 'animate',
                            'args': [None, {'frame': {'duration': 0, 'redraw': False}, 'mode': 'immediate', 'transition': {'duration': 0}, 'fromcurrent': True}]
                        },
                        {
                            'label': 'Pause',
                            'method': 'animate',
                            'args': [[None], {'frame': {'duration': 0, 'redraw': False}, 'mode': 'immediate', 'transition': {'duration': 0}}]
                        },
                    ],
                    'xanchor': 'right',
                    'yanchor': 'top',
                    'x': 0,
                    'y': -0.20,
                    'direction': 'left',
                    # "pad": {"r": 10, "t": 5},
                }
            ],
            # sliders=[
            #     {
            #         'active': 0,
            #         'xanchor': 'left',
            #         'yanchor': 'top',
            #         'len': 0.9,
            #         'x': 0.1,
            #         'y': 0,
            #     }
            # ],
        ),
        frames=[go.Frame(data=go.Scatter(x=xdata, y=h[:, i])) for i in range(h.shape[1])]
    )
    return fig

@callback(
    Output('results-store', 'data'),
    Output('results-fig', 'figure'),
    Trigger('run-button', 'n_clicks'),
    State('inp-icenter', 'value'),
    State('inp-grid_size', 'value'),
    State('inp-timesteps', 'value'),
    State('inp-dt', 'value'),
    State('inp-dx', 'value'),
    State('inp-c', 'value'),
    State('inp-decay', 'value'),
    prevent_initial_call=True
)
def run_simulation(icenter, grid_size, timesteps, dt, dx, c, decay):
    # solver = Tsunami()
    sim_params = solver.SimParams(icenter, grid_size, timesteps, dt, dx, c, decay)
    h = solver.run_solver(sim_params)
    print(h)
    # return h, plot_sim_results(h)

# @callback(
#     Output('slider', 'max'),
#     Output('slider', 'marks'),
#     Trigger('run-button', 'n_clicks'),
#     State('inp-timesteps', 'value'),
#     prevent_initial_call=True
# )
# def set_slider(timesteps):
#     return timesteps, {i: '' for i in range(timesteps)}

# @callback(
#     Output('results-fig', 'figure'),
#     State('results-fig', 'figure'),
#     State('results-store', 'data'),
#     State('inp-dt', 'value'),
#     Input('slider', 'value'),
#     prevent_initial_call=True,
# )
# def set_fig_time(fig, h, dt, step):
#     h = np.array(h)
#     fig['data'][0].update({'y': h[:, int(step)]})
#     return go.Figure(fig)

app.layout = dbc.Container(
    [
        dcc.Store(id='results-store', data=[]),    
        dbc.Row(
            dbc.Col(
                dcc.Markdown('Tsunami simulator', className='h1 text-center')
            )
        ),
        dbc.Row(
            [
                dbc.Col(
                    [
                        dbc.Form(
                            [
                                dbc.Row(
                                    [
                                        dbc.Label("icenter", width=2),
                                        dbc.Col(dbc.Input(placeholder=25, id='inp-icenter', type='number', min=1, step=1, value=25), width=10),
                                    ]
                                )
                            ]
                        ),
                        dbc.Form(
                            [
                                dbc.Row(
                                    [
                                        dbc.Label("grid_size", width=2),
                                        dbc.Col(dbc.Input(placeholder=100, id='inp-grid_size', type='number', min=1, step=1, value=100), width=10),
                                    ]
                                )
                            ]
                        ),
                        dbc.Form(
                            [
                                dbc.Row(
                                    [
                                        dbc.Label("timesteps", width=2),
                                        dbc.Col(dbc.Input(placeholder=100, id='inp-timesteps', type='number', min=1, step=1, value=1000), width=10),
                                    ]
                                )
                            ]
                        ),
                        dbc.Form(
                            [
                                dbc.Row(
                                    [
                                        dbc.Label("dt", width=2),
                                        dbc.Col(dbc.Input(placeholder=1, id='inp-dt', type='number', min=1e-20, value=0.01), width=10),
                                    ]
                                )
                            ]
                        ),
                        dbc.Form(
                            [
                                dbc.Row(
                                    [
                                        dbc.Label("dx", width=2),
                                        dbc.Col(dbc.Input(placeholder=1, id='inp-dx', type='number', min=1, step=1, value=1), width=10),
                                    ]
                                )
                            ]
                        ),
                        dbc.Form(
                            [
                                dbc.Row(
                                    [
                                        dbc.Label("c", width=2),
                                        dbc.Col(dbc.Input(placeholder=1, id='inp-c', type='number', min=1, step=1, value=1), width=10),
                                    ]
                                )
                            ]
                        ),
                        dbc.Form(
                            [
                                dbc.Row(
                                    [
                                        dbc.Label("decay", width=2),
                                        dbc.Col(dbc.Input(placeholder=0.02, id='inp-decay', type='number', min=0, value=0.02), width=10),
                                    ]
                                )
                            ]
                        ),
                    ],
                )
            ]
        ),
        dbc.Row(
            [
                dbc.Col(
                    [
                        dbc.Button('Run simulation', id='run-button', color="success", class_name="top-0 start-50 translate-middle-x")
                    ],
                    width=12,
                )
            ]
        ),
        dbc.Row(
            dbc.Col(
                [
                    dcc.Graph(id='results-fig'),
                    # dcc.Slider(id='slider', min=0, max=1, step=None, updatemode='drag')
                ]
            )
        ),
    ]
)

if __name__ == '__main__':
    app.run(debug=True)