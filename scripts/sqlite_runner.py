print ".headers on: displays the column names"
print ".mode column: displays tab-separated columns"
print ".tables: list tables"
try:
    import apsw
    apsw.main()
except ImportError:
    import subprocess
    import sys
    argv = ["sqlite3","-interactive"] + sys.argv[1:]
    subprocess.call(argv)
