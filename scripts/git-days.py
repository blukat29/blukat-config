import sys
import datetime
import time

stat = {}

for l in sys.stdin.readlines():
    rawdate, hash = l.split()
    tm = time.strptime(rawdate, "%Y-%m-%d")
    dt = datetime.datetime.fromtimestamp(time.mktime(tm))
    stat[dt] = stat.get(dt, 0) + 1

days = stat.keys()
days.sort()
oldest = days[0]
newest = days[-1]

d = oldest
while d <= newest:
    nu = stat.get(d, 0)
    print d, "%2d" % nu, "="*nu
    d = d + datetime.timedelta(days=1)




