#!/bin/sh
cat /proc/meminfo | grep Mem | python ~/blukat-config/scripts/memstat.py
