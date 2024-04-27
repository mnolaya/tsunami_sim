import re
import io

from dash import Dash, dcc
import dash_bootstrap_components as dbc
import plotly.graph_objs as go

import polars as pl

DATA = 'tsunami_out.txt'
with open(DATA, 'r') as f:
    p = re.compile(r'\s+')
    data = [p.sub(',', l.lstrip().rstrip()) for l in f.readlines()]
headers = ['time'] + [f'x_{i+1}' for i, _ in enumerate(data[0].split(',')[1:])]
data.insert(0, ','.join(headers))
df = pl.read_csv(io.StringIO('\n'.join(data)))

app = Dash(__name__, external_stylesheets=[dbc.themes.BOOTSTRAP])

fig = go.Figure(
    data=[
        go.Scatter(
            x=[i for i in range(len(df.columns)-1)], 
            y=df.select(df.filter(pl.col('time') == 1)).select(pl.exclude('time')).to_numpy()[0, :]
        )
    ]
)
app.layout = dbc.Container(
    dbc.Col(
        dbc.Row(
            dcc.Graph(figure=fig)
        )
    )
)

if __name__ == '__main__':
    app.run(debug=True)