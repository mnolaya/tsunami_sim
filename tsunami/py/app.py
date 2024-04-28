import re
import io

from dash import Dash, dcc, Input, Output, callback
from dash.exceptions import PreventUpdate
import dash_bootstrap_components as dbc
import plotly.graph_objs as go
import polars as pl

# Load the shared object libraries for the tsunami simulator
from tsunami.py import _env
_env.load_so()
from tsunami.bin.tsunami import Tsunami

app = Dash(__name__, external_stylesheets=[dbc.themes.MATERIA])

@callback(
    Output('run-button', 'n_clicks'),
    Input('run-button', 'n_clicks'),
    Input('inp-icenter', 'value'),
    Input('inp-grid_size', 'value'),
    Input('inp-timesteps', 'value'),
    Input('inp-dt', 'value'),
    Input('inp-dx', 'value'),
    Input('inp-c', 'value'),
    Input('inp-decay', 'value'),
)
def run_simulation(n_clicks, icenter, grid_size, timesteps, dt, dx, c, decay):
    if n_clicks is None:
        raise PreventUpdate
    else:
        solver = Tsunami()
        solver.run_solver(icenter, grid_size, timesteps, dt, dx, c, decay)
        return n_clicks

# DATA = 'tsunami_out.txt'
# with open(DATA, 'r') as f:
#     p = re.compile(r'\s+')
#     data = [p.sub(',', l.lstrip().rstrip()) for l in f.readlines()]
# headers = ['time'] + [f'x_{i+1}' for i, _ in enumerate(data[0].split(',')[1:])]
# data.insert(0, ','.join(headers))
# df = pl.read_csv(io.StringIO('\n'.join(data)))

# fig = go.Figure(
#     data=[
#         go.Scatter(
#             x=[i for i in range(len(df.columns)-1)], 
#             y=df.select(df.filter(pl.col('time') == 1)).select(pl.exclude('time')).to_numpy()[0, :],
#         )
#     ]
# )
# fig.update_layout(
#     xaxis_title='x [m]',
#     yaxis_title='water height [m]'
# )

# slider_marks = {time: '' for time in df.select(pl.col('time')).to_series()}
# max_time = df.select(pl.col('time')).max().item()
# min_time = df.select(pl.col('time')).min().item()

# def create_fig(time: float = 1) -> go.Figure:
#     return go.Figure(
#         data=[
#             go.Scatter(
#                 x=[i for i in range(len(df.columns)-1)], 
#                 y=df.select(df.filter(pl.col('time') == time)).select(pl.exclude('time')).to_numpy()[0, :],
#             )
#         ]
#     )

# @callback(
#     Output('fig', 'figure'),
#     Input('slider', 'value')
# )
# def set_fig_time(time):
#     return create_fig(time)

app.layout = dbc.Container(
    [    
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
                                        dbc.Col(dbc.Input(placeholder=100, id='inp-timesteps', type='number', min=1, step=1, value=100), width=10),
                                    ]
                                )
                            ]
                        ),
                        dbc.Form(
                            [
                                dbc.Row(
                                    [
                                        dbc.Label("dt", width=2),
                                        dbc.Col(dbc.Input(placeholder=1, id='inp-dt', type='number', min=1, step=1, value=1), width=10),
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
                    # dcc.Graph(id='fig', figure=fig),
                    # dcc.Slider(id='slider', value=min_time, min=min_time, max=max_time, marks=slider_marks, step=None, updatemode='drag')
                ]
            )
        ),
        dbc.Row(dbc.Placeholder(id='ph'))
    ]
)

if __name__ == '__main__':
    app.run(debug=True)