#!/bin/sh

SCRIPT_DIR=$(dirname $(readlink -e $0))
BACKUP_DIR=$HOME/.config.bak.d

# Restore original dotfiles from $BACKUP_DIR
reset () {
  OLD="$HOME/.$1"
  BAK="$BACKUP_DIR/.$1"
  if [ -L $OLD ]; then
    rm $OLD
  fi
  if [ -f $BAK ]; then
    cp $BAK $OLD
  fi
}

reset bashrc
reset vimrc
reset tmux.conf
reset gitconfig
reset gitconfig.common
reset gitignore
reset gdbinit
