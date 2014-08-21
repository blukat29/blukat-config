#!/bin/sh

check () {
  type $1 >/dev/null 2>&1
}
check_fatal() {
  check $1
  if [ $? -ne 0 ]; then
    MISSING="$MISSING $1"
  fi
}

MISSING=""
check_fatal bash
check_fatal vim
check_fatal python
check_fatal ctags
check_fatal tmux
check_fatal gcc
check_fatal gdb
check_fatal make
check_fatal curl
check_fatal build-essential
if [ ! -z "$MISSING" ]; then
  echo "==============================================================="
  echo "    Following packages will be installed:"
  echo "        $MISSING"
  echo "==============================================================="
  sudo apt-get install $MISSING
fi

. $SCRIPT_DIR/basic.sh

