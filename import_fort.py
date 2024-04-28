import os
import sys
# sys.path.append("/home/mnolaya/repos/tsunami/bin")

if 'LD_LIBRARY_PATH' not in os.environ:
    os.environ['LD_LIBRARY_PATH'] = '/home/mnolaya/repos/tsunami/bin'
    # os.environ['ORACLE_HOME'] = '/usr/lib/oracle/XX.Y/client64'
    try:
        os.execv(sys.executable, ["python"] + sys.argv)
    except Exception as e:
        print(e)
        sys.exit(1)
# #
# # import yourmodule
# print('Success:', os.environ['LD_LIBRARY_PATH'])
# # your program goes here

# print(sys.argv)

from tsunami import Tsunami

Tsunami().run_solver(25, 100, 100, 1, 1, 1, 0.02)