import atexit
import os
import pprint
import readline
import sys

## Interactive shell history

# History file located in ~/.config dir
_HISTFILE = os.path.join(os.getenv('HOME'), '.config/.python_history')

# Read history file
if os.path.exists(_HISTFILE):
    readline.read_history_file(_HISTFILE)

# Set history file location
def save_hist():
    readline.write_history_file(_HISTFILE)
readline.set_history_length(1000)
atexit.register(save_hist)
del save_hist

## Color prompt
def ascii_escape(body):
    return '\001\033[%sm\002' % body
cCyan = ascii_escape('0;36')
cReset = ascii_escape('0')
sys.ps1 = cCyan + '>>> ' + cReset
sys.ps2 = cCyan + '... ' + cReset
del ascii_escape,cCyan,cReset

## pprint output
def my_displayhook(value):
    # Set _ variable to last result
    if value is not None:
        try:
            import __builtin__
            __builtin__._ = value
        except ImportError:
            __builtins__._ = value
    # pretty print result
    pprint.pprint(value)
sys.displayhook = my_displayhook
del my_displayhook

