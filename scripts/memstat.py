import sys

total = int(sys.stdin.readline().split()[1])
free = int(sys.stdin.readline().split()[1])
used = total - free
rate = int(used*100.0/total)
s = "%.1f/%.1fG(%d%%)" % (used/1048576.0, total/1048576.0, rate)
print "%14s" % s

