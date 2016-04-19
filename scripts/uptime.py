import sys
import re
f = sys.stdin.read()
uptime, loadavg = re.search("up (.*)\d+ users.*load average: (.*)", f).groups()
uptime = uptime.lstrip().rstrip().rstrip(',')
loadavg = loadavg.replace(',','')
sys.stdout.write("[up %s][%s]" % (uptime, loadavg))
