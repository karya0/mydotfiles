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

def ExecuteFredCommand(cmd):
    print cmd

class FReDUndo(gdb.Command):
    """fred-undo [n]: Undo last n debugger commands."""
    name = "fred-undo"
    def __init__ (self):
        gdb.Command.__init__(self, name, gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(name, arg)

class FReDReverseNext(gdb.Command):
    """fred-reverse-next [n], fred-rn [n]:  Reverse-next n times."""
    def __init__ (self):
        gdb.Command.__init__(self, "fred-rn", gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self, arg)

class FReDReverseStep(gdb.Command):
    """fred-reverse-step [n], fred-rs [n]:  Reverse-step n times."""
    def __init__ (self):
        gdb.Command.__init__(self, "fred-rs", gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self, arg)

class FReDReverseFinish(gdb.Command):
    """fred-reverse-finish , fred-rf:        Reverse execute until function exited."""
    def __init__ (self):
        gdb.Command.__init__(self, "fred-rf", gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self, arg)

class FReDReverseContinue(gdb.Command):
    """fred-reverse-continue , fred-rc:      Reverse execute to previous breakpoint."""
    def __init__ (self):
        gdb.Command.__init__(self, "fred-rc", gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self, arg)

class FReDCheckpoint(gdb.Command):
    """fred-checkpoint, fred-ckpt: Request a new checkpoint to be made."""
    def __init__ (self):
        gdb.Command.__init__(self, "fred-ckpt", gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self, arg)

class FReDRestart(gdb.Command):
    """fred-restart [n]:           Restart from a checkpoint."""
    def __init__ (self):
        gdb.Command.__init__(self, "fred-restart", gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self, arg)

class FReDReverseWatch(gdb.Command):
    """fred-reverse-watch <EXPR>, fred-rw <EXPR>:
                Reverse execute until expression EXPR changes."""
    def __init__ (self):
        gdb.Command.__init__(self, "fred-rw", gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self, arg)

class FReDSource(gdb.Command):
    """fred-source <FILE>:         Read commands from source file."""
    def __init__ (self):
        gdb.Command.__init__(self, "fred-source", gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self, arg)

class FReDList(gdb.Command):
    """fred-list:                  List the available branches and checkpoints."""
    def __init__ (self):
        gdb.Command.__init__(self, "fred-list", gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self, arg)

class FReDBranch(gdb.Command):
    """fred-branch <NAME>:         Create new branch <NAME> from current point."""
    def __init__ (self):
        gdb.Command.__init__(self, "fred-branch", gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self, arg)

class FReDSwitch(gdb.Command):
    """fred-switch <NAME>:         Switch to branch <NAME>."""
    def __init__ (self):
        gdb.Command.__init__(self, "fred-switch", gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self, arg)

class FReDHelp(gdb.Command):
    """fred-help:                  Display this help message."""
    def __init__ (self):
        gdb.Command.__init__(self, "fred-help", gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self, arg)

class FReDHistory(gdb.Command):
    """fred-history:               Display your command history up to this point."""
    def __init__ (self):
        gdb.Command.__init__(self, "fred-history", gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self, arg)

class FReDDebug(gdb.Command):
    """fred-debug :                 (*Experts only) Drop into a pdb prompt for FReD."""
    def __init__ (self):
        gdb.Command.__init__(self, "fred-debug", gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self, arg)

class FReDHelp(gdb.Command):
    """fred-help:                  Display this help message."""
    def __init__ (self):
        gdb.Command.__init__(self, "fred-help", gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        print """FReD commands:
(all optional 'count' arguments default to 1)
  fred-undo [n]:         Undo last n debugger commands.
  fred-reverse-next [n], fred-rn [n]:  Reverse-next n times.
  fred-reverse-step [n], fred-rs [n]:  Reverse-step n times.
  fred-reverse-finish, fred-rf:        Reverse execute until function exited.
  fred-reverse-continue, fred-rc:      Reverse execute to previous breakpoint.
  fred-checkpoint, fred-ckpt: Request a new checkpoint to be made.
  fred-restart [n]:           Restart from a checkpoint.
  fred-reverse-watch <EXPR>, fred-rw <EXPR>:
                              Reverse execute until expression EXPR changes.
  fred-source <FILE>:         Read commands from source file.
  fred-list:                  List the available branches and checkpoints.
  fred-branch <NAME>:         Create new branch <NAME> from current point.
  fred-switch <NAME>:         Switch to branch <NAME>.
  fred-help:                  Display this help message.
  fred-history:               Display your command history up to this point.
  fred-debug:                 (*Experts only) Drop into a pdb prompt for FReD.
"""
        sys.stdout.flush()

FReDUndo()
FReDReverseNext()
FReDReverseStep()
FReDReverseFinish()
FReDReverseContinue()
FReDCheckpoint()
FReDRestart()
FReDReverseWatch()
FReDSource()
FReDList()
FReDBranch()
FReDSwitch()
FReDHelp()
FReDHistory()
FReDDebug()
