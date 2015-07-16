source ~/.gdb/stl-views.gdb
source ~/.gdb/color.py
#source ~/.gdb/libpython.py
# source ~/.gdb/python.gdb
handle SIGTSTP pass noprint nostop
set history filename ~/.gdb_history
set history save
set auto-load safe-path /

define gpath
    p global_log._path.c_str()
