#!/bin/sh
SCRIPTS_DIR=$(dirname $(readlink -e $0))
SYSTEM=`uname -s`

case "$SYSTEM" in
    "Darwin")
        uptime | python $SCRIPTS_DIR/uptime.py
        ;;
    "Linux")
        echo -n "$(uptime | python $SCRIPTS_DIR/uptime.py)"
        echo -n "$(cat /proc/meminfo | grep Mem | python $SCRIPTS_DIR/memstat.py)"
        ;;
esac
