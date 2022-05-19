import shlex
import subprocess
import sys


def nopush(name):
    print("Disabling git push to the remote '{}'".format(name))
    cmdline = "git remote set-url --push {} nopush".format(name)
    print(cmdline)
    subprocess.check_call(shlex.split(cmdline))

if __name__ == '__main__':
    if len(sys.argv) > 1:
        name = sys.argv[1]
    else:
        name = 'origin'
    nopush(name)
