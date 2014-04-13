#!/bin/sh
BASE=$HOME

if [ -f $BASE/.vimrc ]; then
    mv $BASE/.vimrc $BASE/.vimrc.old
fi
cp ./blukat.vimrc $BASE/.vimrc

if [ -f $BASE/.bashrc ]; then
    mv $BASE/.bashrc $BASE/.bashrc.old
fi
cp ./blukat.bashrc $BASE/.bashrc
source $BASE/.bashrc

if [ -f $BASE/.tmux.conf ]; then
    mv $BASE/.tmux.conf $BASE/.tmux.conf.old
fi
cp ./blukat.tmux.conf $BASE/.tmux.conf

type -a tmux
if [ $? != 0 ]; then
  echo "tmux is not installed. run \"sh tmux_local_install.sh\""
fi

echo "Config complete. Undo config using unconfig-blukat.sh"
