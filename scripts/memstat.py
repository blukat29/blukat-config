import sys

total = sys.stdin.readline().split()[:2]
used = sys.stdin.readline().split()[:2]

unit = {"K":1, "M":1024, "G":1024*1024}

total = int(total[0]) * unit[total[1]]
used = int(used[0]) * unit[used[1]]

def sizefmt(n):
    if n < 1024:
        return "%d kB" % n
    n = n / 1024.0
    if n < 2048:
        return "%d MB" % n
    n = n / 1024.0
    return "%.2f GB" % n

print "%s / %s" % (sizefmt(used), sizefmt(total))

