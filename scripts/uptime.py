import sys
import re
f = sys.stdin.read()
uptime, loadavg = re.search("up (.*)\d+ user..*load average: (.*)", f).groups()
uptime = uptime.strip().rstrip(',')
uptime = re.sub(",\s+", " ", uptime)
loadavg = loadavg.replace(',','')
sys.stdout.write("[up %s][%s]" % (uptime, loadavg))
