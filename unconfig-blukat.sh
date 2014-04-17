#!/bin/sh
BASE=$HOME

if [ -f $BASE/.vimrc.old ]; then
    rm $BASE/.vimrc
    mv $BASE/.vimrc.old $BASE/.vimrc
fi

if [ -f $BASE/.bashrc.old ]; then
    rm $BASE/.bashrc
    mv $BASE/.bashrc.old $BASE/.bashrc
fi

if [ -f $BASE/.tmux.conf.old ]; then
    rm $BASE/.tmux.conf
    mv $BASE/.tmux.conf.old $BASE/.tmux.conf
fi

echo "Unconfig almost complete. Remove tmux by yourself."

