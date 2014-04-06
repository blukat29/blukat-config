#!/bin/sh
BASE=$HOME

rm $BASE/.vimrc
if [ -f $BASE/.vimrc.old ]; then
    mv $BASE/.vimrc.old $BASE/.vimrc
fi

rm $BASE/.bashrc
if [ -f $BASE/.bashrc.old ]; then
    mv $BASE/.bashrc.old $BASE/.bashrc
fi

rm $BASE/.tmux.conf
if [ -f $BASE/.tmux.conf.old ]; then
    mv $BASE/.tmux.conf.old $BASE/.tmux.conf
fi

echo "Unconfig almost complete. Remove tmux by yourself."

