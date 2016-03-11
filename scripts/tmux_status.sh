#!/bin/sh
SCRIPTS_DIR="$( cd "$( dirname $(readlink -e "${BASH_SOURCE[0]}") )" && pwd )"
SYSTEM=`uname -s`

case "$SYSTEM" in
    "Darwin") top -l 1 -s 0 | grep PhysMem | python $SCRIPTS_DIR/memstat.py Darwin
        ;;
    "Linux") cat /proc/meminfo | grep Mem | python $SCRIPTS_DIR/memstat.py Linux
        ;;
esac
