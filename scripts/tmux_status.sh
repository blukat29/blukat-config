#!/bin/sh
SCRIPTS_DIR=$(dirname $(readlink -e $0))
SYSTEM=`uname -s`

case "$SYSTEM" in
    "Darwin") top -l 1 -s 0 | grep PhysMem | python $SCRIPTS_DIR/memstat.py Darwin
        ;;
    "Linux")
        echo -n "[$(cat /proc/loadavg | cut -c -14)]"
        echo -n "[$(cat /proc/meminfo | grep Mem | python $SCRIPTS_DIR/memstat.py Linux)]"
        ;;
esac
