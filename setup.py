from setuptools import setup, find_packages, Extension

from Cython.Build import cythonize
import numpy as np

extensions = [
    Extension(
        "tsunami_fort", ["tsunami/fort/tsunami.pyx"],
        include_dirs=[np.get_include(), "tsunami/fort"],
        libraries=["tsunami"],
        library_dirs=["tsunami/bin"],
        runtime_library_dirs=["tsunami/bin"]
    )
]

setup(
    name="tsunami",
    version="0.0.1",
    packages=find_packages(),
    ext_modules=cythonize(extensions),
)