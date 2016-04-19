import sys
total = int(sys.stdin.readline().split()[1])
free = int(sys.stdin.readline().split()[1])
used = (total - free) / 1048576.0
total = total / 1048576.0
sys.stdout.write("[%.1fG/%.1fG(%d%%)]" % (used, total, (used * 100 / total)))
