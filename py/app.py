import re
import io

from dash import Dash, dcc, Input, Output, callback
import dash_bootstrap_components as dbc
import plotly.graph_objs as go

import polars as pl

app = Dash(__name__, external_stylesheets=[dbc.themes.MATERIA])

DATA = 'tsunami_out.txt'
with open(DATA, 'r') as f:
    p = re.compile(r'\s+')
    data = [p.sub(',', l.lstrip().rstrip()) for l in f.readlines()]
headers = ['time'] + [f'x_{i+1}' for i, _ in enumerate(data[0].split(',')[1:])]
data.insert(0, ','.join(headers))
df = pl.read_csv(io.StringIO('\n'.join(data)))


fig = go.Figure(
    data=[
        go.Scatter(
            x=[i for i in range(len(df.columns)-1)], 
            y=df.select(df.filter(pl.col('time') == 1)).select(pl.exclude('time')).to_numpy()[0, :],
        )
    ]
)
fig.update_layout(
    xaxis_title='x [m]',
    yaxis_title='water height [m]'
)

slider_marks = {time: '' for time in df.select(pl.col('time')).to_series()}
max_time = df.select(pl.col('time')).max().item()
min_time = df.select(pl.col('time')).min().item()

def create_fig(time: float = 1) -> go.Figure:
    return go.Figure(
        data=[
            go.Scatter(
                x=[i for i in range(len(df.columns)-1)], 
                y=df.select(df.filter(pl.col('time') == time)).select(pl.exclude('time')).to_numpy()[0, :],
            )
        ]
    )

@callback(
    Output('fig', 'figure'),
    Input('slider', 'value')
)
def set_fig_time(time):
    return create_fig(time)

app.layout = dbc.Container(
    [    
        dbc.Row(
            dbc.Col(
                dcc.Markdown('Tsunami simulator', className='h1 text-center')
            )
        ),
        dbc.Row(
            dbc.Col(
                [
                    dcc.Graph(id='fig', figure=fig),
                    dcc.Slider(id='slider', value=min_time, min=min_time, max=max_time, marks=slider_marks, step=None, updatemode='drag')
                ]
            )
        )
    ]
)

if __name__ == '__main__':
    app.run(debug=True)