import sys
print(\
"""Cheatsheet:
  .tables: list tables
  .schema TABLE: show table schema
  .dump TABLE: dump table as SQL""")
options=["-interactive","-header","-list","-separator", "\t"]
try:
    import apsw
    args = options + sys.argv[1:]
    apsw.Shell(args=args).cmdloop()
    print("")
except ImportError:
    import subprocess
    argv = ["sqlite3"] + options + sys.argv[1:]
    subprocess.call(argv)
