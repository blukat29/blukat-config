import atexit
import code
import datetime
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
class Prompt(object):
    cCyan = ascii_escape('0;36')
    cReset = ascii_escape('0')
    def __str__(self):
        now = datetime.datetime.now()
        clock = '%02d:%02d:%02d' % (now.hour, now.minute, now.second)
        return self.cCyan + clock + ' >>> ' + self.cReset
sys.ps1 = Prompt()
sys.ps2 = '         ... '
del ascii_escape,Prompt

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

## cls command
class ClsCmd(object):
    def __repr__(self):
        if os.name == 'nt':
            os.system('cls')
        else:
            os.system('/usr/bin/clear')
        return ''
cls = ClsCmd()
clear = ClsCmd()

## exit command
class ExitCmd(object):
    orig_exit = exit
    def __repr__(self):
        self.orig_exit()
        return ''
exit = ExitCmd()
quit = ExitCmd()

## Special command '?' for help
class ConsoleWithHelp(code.InteractiveConsole):
    def __init__(self, *args, **kwargs):
        code.InteractiveConsole.__init__(self, *args, **kwargs)
    def raw_input(self, *args):
        line = code.InteractiveConsole.raw_input(self, *args)
        if line.strip() == '?':
            return 'help(_)'
        elif line.strip() == '.':
            return 'dir(_)'
        return line
c = ConsoleWithHelp(locals=locals())
banner = '''
Type "?" for help about last result.
Type "." for list of attributes and methods of last result.
'''.strip()
c.interact(banner=banner)
# Exit when console exits.
sys.exit()
