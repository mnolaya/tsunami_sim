from setuptools import setup, find_packages, Extension

from Cython.Build import cythonize
import numpy as np

extensions = [
    Extension(
        "tsunami.fort.tsufort", ["tsunami/fort/tsufort.pyx"],  # Name of Python module to be created and source files to create module from
        include_dirs=[np.get_include(), "tsunami/include"],
        libraries=["tsufort"],  # Name of libraries to link
        library_dirs=["tsunami/bin"],  #  Required for linking with other libraries
        runtime_library_dirs=["tsunami/bin"]  # Required for dynamic (i.e., *.so or *.dll) linking at runtime with libraries built externally (e.g., gfortran)
    )
]

setup(
    name="tsunami",
    # version="0.0.1",
    packages=find_packages(),
    ext_modules=cythonize(extensions),
)