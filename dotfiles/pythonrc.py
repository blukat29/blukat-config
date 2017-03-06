import atexit
import code
import datetime
import os
import pprint
import readline
import signal
import subprocess
import sys


## ===== Interactive shell history ====================== ##

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


## ===== Prompt ========================================= ##

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


## ===== Pretty print output ============================ ##


class MyDisplayHook(object):

    def __init__(self):
        self.rows = 25
        self.cols = 80
        self.update_terminal_size()
        signal.signal(signal.SIGWINCH, self.on_sigwinch)

    def update_terminal_size(self):
        rows, cols = subprocess.check_output('stty size', shell=True).strip().split()
        self.rows = int(rows)
        self.cols = int(cols)

    def on_sigwinch(self, signum, frame):
        self.update_terminal_size()

    def print_iterable(self, iterable, encloser):

        # Columnify the iterable.
        strings = [repr(x) for x in iterable]
        widest = max([0] + [len(x) for x in strings])
        padded = [x.ljust(widest) for x in strings]
        items_per_line = int((self.cols - 4) / (widest + 2))

        # List items in a python list or tuple format.
        out = encloser[0]
        for i, item in enumerate(padded):
            out += item + ', '
            if i % items_per_line == (items_per_line - 1):
                out += '\n '
        out += encloser[1]

        # Print it out.
        print(out)

    def __call__(self, value):
        # Set _ variable to last result
        if value is not None:
            try:
                import __builtin__
                __builtin__._ = value
            except ImportError:
                __builtins__._ = value
        # pretty print result
        if isinstance(value, list):
            self.print_iterable(value, '[]')
        elif isinstance(value, tuple):
            self.print_iterable(value, '()')
        else:
            pprint.pprint(value)

sys.displayhook = MyDisplayHook()
del MyDisplayHook


## ===== screen clear command aliases =================== ##

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


## ===== special commands about last result ============= ##

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


## ===== Launches the shell ============================= ##

banner = '''
Type "?" for help about last result.
Type "." for list of attributes and methods of last result.
'''.strip()
c = ConsoleWithHelp(locals=locals())
c.interact(banner=banner)

# Exit when console exits.
sys.exit()
