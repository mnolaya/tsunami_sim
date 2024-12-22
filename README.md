# Tsunami simulator

## Requirements

- gfortran
- make
- Python 3.10+

## Abstract

This program is based upon the tsunami simulator project presented in, "Modern Fortran: Building efficient parallel applications," by Milan Curcic. Python is used to drive the frontend via a web-based GUI built using the Plotly Dash 
library. The solver (as per the project) is written in Fortran, with interfaces between Python and Fortran handlded using
C-bindings native to Fortran and the Cython Python library.

## Installation

Installation of the package must be performed in the following order:

1. Build Fortran libraries
2. Build Cython libraries for interfacing between Python and Fortran
3. Install package to Python environment

### Building Fortran libraries

A Makefile is provided to aid in the build process. Simply run `make` in the command line, and the binaries will be compiled and placed in the correct bin directory for the package.

### Building Cython libraries

The Cython libraries are used to interface between Python and Fortran, thus allowing importing of procedures written in Fortran into a Python script. To build:

```
python setup.py build_ext --inplace
```

### Install package to Python environment

*Development only*

```
python -m pip install -e .
```

## Running the app

*Development only*

If the package was installed in development mode (`-e` option), then the package must be run as a module to start the simulator app.

```
python -m tsunami.py.app
```