#!/usr/bin/python

# Here are some gdb commands written in python using the gdb Python API
# described here:
#   http://sourceware.org/gdb/current/onlinedocs/gdb/Python-API.html#Python-API

from __future__ import with_statement
import subprocess
import string
import os
import re
import gdb

MAGENTA = '\033[95m'
BLUE = '\033[94m'
OKGREEN = '\033[92m'
WARNING = '\033[93m'
FAIL = '\033[91m'
ENDC = '\033[0m'
PC = MAGENTA
FUNCTION = OKGREEN
FILE = BLUE
LINE = BLUE


class BacktraceFrame():
    """Represents one frame in the stack trace (backtrace).
    It's not necessary to use all of these fields."""
    def __init__(self):
        self.n_frame_num = 0
        self.s_addr      = ""
        self.s_function  = ""
        self.s_args      = ""
        self.s_file      = ""
        self.n_line      = 0

    def __repr__(self):
        return "frame: " + str((self.n_frame_num, self.s_addr, self.s_function,
                                self.s_args, self.s_file, self.n_line))

    def addr(self):
        """Return frame address."""
        return self.s_line

    def function(self):
        """Return function name."""
        return self.s_function

    def args(self):
        """Return function arguments."""
        return self.s_args

    def file(self):
        """Return file name."""
        return self.s_file

    def line(self):
        """Return line number."""
        return self.n_line

class ColorBT(gdb.Command):
    """Colorful backtrace"""
    def __init__(self):
        gdb.Command.__init__(self, "cbt", gdb.COMMAND_STACK)

    def printFrame (self, count, frame):
        if not frame.is_valid():
            return
        print "#%2d" % (count),
        print " %s0x%x%s" % (PC, frame.pc(), ENDC),
        print " in %s%s%s" % (FUNCTION, frame.name(), ENDC),
        sal = frame.find_sal()
        if sal.is_valid():
            if sal.symtab != None:
                print " at %s%s%s" % (FILE, frame.find_sal().symtab.filename, ENDC),
                print "\b%s:%s" % (FAIL, ENDC),
                print "\b%s%d%s" % (LINE, frame.find_sal().line, ENDC)
            else:
                print sal
        #print " in %s%s%s" % (FUNCTION, frame.name(), ENDC)
        return

    def oldbt(self, arg):
        nframes = 0
        if arg == '':
            nframes = -1
        else:
            nframes = int(arg)
        frame = gdb.newest_frame()
        count = 0
        while nframes != 0:
            if frame == None:
                break
            self.printFrame(count, frame)
            frame = frame.older()
            nframes = nframes - 1
            count = count + 1

    def print_backtrace_frame(self, match_obj):
        """Return a BacktraceFrame from the given re Match object.
        The Match object should be a tuple (result of gre_backtrace_frame.)"""
        _frame_num = int(match_obj[0])
        _addr      = match_obj[1]
        _function  = match_obj[2]
        _args      = match_obj[3]
        _atfrom    = match_obj[4]
        _file      = match_obj[5]
        #_line      = int(match_obj[5])

        print "#%s" % (_frame_num),
        print " %s%s%s" % (PC, _addr, ENDC),
        print " in %s%s%s" % (FUNCTION, _function, ENDC),
        print "(%s%s%s)" % (FILE, _args, ENDC),
        print "%s %s%s%s" % (_atfrom, FILE, _file, ENDC),
        #print "\b%s:%s" % (FAIL, ENDC),
        #print "\b%s%d%s" % (LINE, frame.find_sal().line, ENDC)
        print ""
        return

    def newbt(self, arg):
        regexp = "^#(\d+)\s+(0x[0-9a-f]+)? in (.+?)\s+\((.*)\)\s+" \
                + "(at|from)\s+(.+)$"
        backtrace = gdb.execute("bt " + arg, True, True)
 
        bt_list = re.findall(regexp, backtrace, re.MULTILINE)
        for f in bt_list:
            self.print_backtrace_frame(f)

    def invoke(self, arg, from_tty):
        #self.oldbt(arg)
        self.newbt(arg)

ColorBT()

class ColorBTObj(gdb.Command):
    """Colorful backtrace"""
    def __init__(self):
        gdb.Command.__init__(self, "cbto", gdb.COMMAND_STACK)

    def printFrame (self, count, frame):
        if not frame.is_valid():
            return
        print "#%2d" % (count),
        print " %s0x%x%s" % (PC, frame.pc(), ENDC),
        print " in %s%s%s" % (FUNCTION, frame.name(), ENDC),
        sal = frame.find_sal()
        if sal.is_valid():
            if sal.symtab != None:
                print " at %s%s%s" % (FILE, frame.find_sal().symtab.objfile.filename, ENDC),
                #print "\b%s:%s" % (FAIL, ENDC),
                #print "\b%s%d%s" % (LINE, frame.find_sal().line, ENDC)
            else:
                print sal,
        print ""
        #print " in %s%s%s" % (FUNCTION, frame.name(), ENDC)
        return

    def invoke(self, arg, from_tty):
        nframes = 0
        if arg == '':
            nframes = -1
        else:
            nframes = int(arg)
        frame = gdb.newest_frame()
        count = 0
        while nframes != 0:
            if frame == None:
                break
            self.printFrame(count, frame)
            frame = frame.older()
            nframes = nframes - 1
            count = count + 1
ColorBTObj()
