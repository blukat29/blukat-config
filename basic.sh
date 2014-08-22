#!/bin/sh

SCRIPT_DIR=$(dirname $(readlink -e $0))
BACKUP_DIR=$HOME/.config.bak.d

# Original dotfiles in home directory are copied into $BACKUP_DIR
if [ ! -d "$BACKUP_DIR" ]; then
  mkdir "$BACKUP_DIR"
fi
relpath() {
  python -c "import os.path; print os.path.relpath('$1','${2:-$PWD}')"
}
setup () {
  OLD="$HOME/.$1"
  BAK="$BACKUP_DIR/.$1"
  NEW="$SCRIPT_DIR/dotfiles/$1"
  if [ -f $OLD ]; then
    if [ -L $OLD ]; then
      rm $OLD
    else
      mv $OLD $BAK
    fi
  fi
  ln -s $(relpath $NEW $HOME) $OLD
}

setup bashrc
setup vimrc
setup tmux.conf
setup gitconfig

if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

