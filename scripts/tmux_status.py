#!/usr/bin/env python3
import platform
import re
import subprocess
import sys


def cmd(cmd):
    return subprocess.check_output(cmd).decode('utf-8')

def show_uptime():
    f = cmd(['uptime'])
    uptime, loadavg = re.search("up (.*)\d+ user.*load.*: (.*)", f).groups()
    uptime = uptime.strip().rstrip(',')
    uptime = re.sub(",\s+", " ", uptime)
    loadavg = loadavg.replace(',','')
    sys.stdout.write("[up %s][%s]" % (uptime, loadavg))

def show_meminfo():
    f = cmd(['head', '/proc/meminfo'])
    for line in f.splitlines():
        if line.startswith('MemTotal'):
            total = int(line.split()[1])
        elif line.startswith('MemFree'):
            free = int(line.split()[1])
            break
    used = (total - free) / 1048576.0
    total = total / 1048576.0
    sys.stdout.write("[%.1fG/%.1fG(%d%%)]" % (used, total, (used * 100 / total)))

if __name__ == '__main__':
    if platform.system() == 'Linux':
        show_uptime()
        show_meminfo()
    elif platform.system() == 'Darwin':
        show_uptime()
