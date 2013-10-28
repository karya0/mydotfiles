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

def ExecuteFredCommand(cmd, arg):
    print cmd, arg

class FRedInit(gdb.Command):
    def __init__(self):
        self.name = "fred-init"
        gdb.Command.__init__(self, self.name, gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        print "Initializing"
FRedInit()

class FRedExecute(gdb.Command):
    def __init__(self):
        self.name = "fred-ex"
        gdb.Command.__init__(self, self.name, gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        res = gdb.execute(arg, True, True)
FRedExecute()

class FReDUndo(gdb.Command):
    """Undo last n debugger commands.
Usage: fred-undo [n]
"""
    def __init__ (self):
        self.name = "fred-undo"
        gdb.Command.__init__(self, self.name, gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self.name, arg)

class FReDReverseNext(gdb.Command):
    """Reverse-next n times.
Usage: fred-reverse-next [n], fred-rn [n]
"""
    def __init__ (self):
        self.name = "fred-rn"
        gdb.Command.__init__(self, self.name, gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self.name, arg)

class FReDReverseStep(gdb.Command):
    """Reverse-step n times.
Usage: fred-reverse-step [n], fred-rs [n]
"""
    def __init__ (self):
        self.name = "fred-rs"
        gdb.Command.__init__(self, self.name, gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self.name, arg)

class FReDReverseFinish(gdb.Command):
    """Reverse execute until function exited."""
    def __init__ (self):
        self.name = "fred-rf"
        gdb.Command.__init__(self, self.name, gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self.name, arg)

class FReDReverseContinue(gdb.Command):
    """Reverse execute to previous breakpoint."""
    def __init__ (self):
        self.name = "fred-rc"
        gdb.Command.__init__(self, self.name, gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self.name, arg)

class FReDCheckpoint(gdb.Command):
    """Request a new checkpoint to be made."""
    def __init__ (self):
        self.name = "fred-ckpt"
        gdb.Command.__init__(self, self.name, gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self.name, arg)

class FReDRestart(gdb.Command):
    """Restart from a checkpoint.
Usage: fred-restart [n]
"""
    def __init__ (self):
        self.name = "fred-restart"
        gdb.Command.__init__(self, self.name, gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self.name, arg)

class FReDReverseWatch(gdb.Command):
    """Reverse execute until expression EXPR changes.
Usage: fred-reverse-watch <EXPR>, fred-rw <EXPR>
"""
    def __init__ (self):
        self.name = "fred-rw"
        gdb.Command.__init__(self, self.name, gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self.name, arg)

class FReDSource(gdb.Command):
    """Read commands from source file.
Usage: fred-source <FILE>
"""
    def __init__ (self):
        self.name = "fred-source"
        gdb.Command.__init__(self, self.name, gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self.name, arg)

class FReDList(gdb.Command):
    """List the available branches and checkpoints."""
    def __init__ (self):
        self.name = "fred-list"
        gdb.Command.__init__(self, self.name, gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self.name, arg)

class FReDBranch(gdb.Command):
    """Create new branch <NAME> from current point.
Usage: fred-branch <NAME>
"""
    def __init__ (self):
        self.name = "fred-branch"
        gdb.Command.__init__(self, self.name, gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self.name, arg)

class FReDSwitch(gdb.Command):
    """Switch to branch <NAME>.
Usage: fred-switch <NAME>
"""
    def __init__ (self):
        self.name = "fred-switch"
        gdb.Command.__init__(self, self.name, gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self.name, arg)

class FReDHistory(gdb.Command):
    """Display your command history up to this point."""
    def __init__ (self):
        self.name = "fred-history"
        gdb.Command.__init__(self, self.name, gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self.name, arg)

class FReDDebug(gdb.Command):
    """(*Experts only) Drop into a pdb prompt for FReD."""
    def __init__ (self):
        self.name = "fred-debug"
        gdb.Command.__init__(self, self.name, gdb.COMMAND_STACK)
    def invoke (self, arg, from_tty):
        ExecuteFredCommand(self.name, arg)

class FReDHelp(gdb.Command):
    """Display this help message."""
    def __init__ (self):
        self.name = "fred-help"
        gdb.Command.__init__(self, self.name, gdb.COMMAND_STACK)
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
