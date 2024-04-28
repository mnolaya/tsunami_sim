from setuptools import setup, Extension

from Cython.Build import cythonize
import numpy as np

extensions = [
    Extension(
        "tsunami", ["fort/tsunami.pyx"],
        include_dirs=[np.get_include(), "/home/mnolaya/repos/tsunami/bin", "/home/mnolaya/repos/tsunami/fort"],
        libraries=["tsunami"],
        library_dirs=["/home/mnolaya/repos/tsunami/bin"],
    )
]


setup(
    # name="test",
    ext_modules=cythonize(extensions)
)