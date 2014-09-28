import sys

raw = sys.stdin.read()

stat = {}
max = 0

for commit in raw.split("\n\n"):
    commit = commit.split("\n")
    head = commit[0]
    body = filter(None, commit[1:])

    date, sha1 = head.split(" ")

    pos = 0
    neg = 0
    for change in body:
        p, n, name = change.split("\t")
        if p == "-":
            continue
        pos += int(p)
        neg += int(n)

    print sha1, pos, neg

