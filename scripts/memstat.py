import sys

isnum = lambda x: x in "0123456789"

if "Darwin" in sys.argv[1]:
    line = sys.stdin.read().split()
    used = line[1]
    unused = line[5]
    used = int(filter(isnum, used)) / 1024.0
    unused = int(filter(isnum, unused)) / 1024.0
    total = used + unused
    print "%.1fG/%.1fG(%d%%)" % (used, total, (used * 100 / total))
elif "Linux" in sys.argv[1]:
    total = int(sys.stdin.readline().split()[1])
    free = int(sys.stdin.readline().split()[1])
    used = (total - free) / 1048576.0
    total = total / 1048576.0
    print "%.1fG/%.1fG(%d%%)" % (used, total, (used * 100 / total))

