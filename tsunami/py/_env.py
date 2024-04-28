import os
import sys

SO_LIBPATH = 'tsunami/bin'

def load_so():
    if 'LD_LIBRARY_PATH' not in os.environ:
        os.environ['LD_LIBRARY_PATH'] = SO_LIBPATH
        try:
            os.execv(sys.executable, ["python"] + sys.argv)
        except Exception as e:
            print(e)
            sys.exit(1)