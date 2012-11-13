source ~/.gdb/stl-views.gdb
source ~/.gdb/color.py
#source ~/.gdb/libpython.py
# source ~/.gdb/python.gdb
handle SIGTSTP pass noprint nostop

define gpath
    p global_log._path.c_str()
