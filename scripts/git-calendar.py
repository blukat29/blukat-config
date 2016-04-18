#!/usr/bin/env python
from __future__ import print_function
import datetime
import subprocess
try:
    import dateutil.parser
except ImportError:
    print("You need python-dateutil package.")
    exit(1)

def month_slug(date):
    return "%4s.%02d" % (date.year, date.month)

def summary(log):
    dates = list(map(dateutil.parser.parse, log.splitlines()))

    counts = {}
    for date in dates:
        slug = month_slug(date)
        counts[slug] = counts.get(slug, 0) + 1

    probe = dates[0]
    while probe > dates[-1]:
        probe -= datetime.timedelta(days=31)
        slug = month_slug(probe)
        if slug not in counts:
            counts[slug] = 0

    max_value = max(counts.values())
    for key in sorted(counts, reverse=True):
        value = counts[key]
        bar = "+" * int((value * 30) / max_value)
        print (key, "%3d" % value, bar)

if __name__ == '__main__':
    log = subprocess.check_output(["git","log","--pretty=format:'%cI'"])
    summary(log)
