import pathlib
import os
import sys

SO_LIBPATH = pathlib.Path(__file__).parent.parent.joinpath('bin')

if 'LD_LIBRARY_PATH' not in os.environ:
    os.environ['LD_LIBRARY_PATH'] = SO_LIBPATH.as_posix()
    try:
        os.execv(sys.executable, ["python"] + sys.argv)
    except Exception as e:
        print(e)
        sys.exit(1)