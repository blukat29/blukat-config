#!/bin/sh

SCRIPT_DIR=$(dirname $(readlink -e $0))
BACKUP_DIR=$HOME/.config.bak.d

# Original dotfiles in home directory are copied into $BACKUP_DIR
if [ ! -d "$BACKUP_DIR" ]; then
  mkdir "$BACKUP_DIR"
fi

relpath() {
  # In case python is not installed (e.g. Ubuntu 16.04)
  type "python" 1>/dev/null 2>/dev/null
  if [ "$?" = "0" ]; then
    python -c "import os.path; print os.path.relpath('$1','${2:-$PWD}')"
  else
    echo "$1"
  fi
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
setup bashrc.conf
setup vimrc
setup tmux.conf
setup gitconfig
setup gitconfig.common
setup gitignore
setup gdbinit

# Install Vim-Plug
if [ ! -f ~/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
vim +PlugInstall +qall

# Install GEF gdb wrapper
if [ ! -f ~/.local/gef.py ]; then
  wget -O ~/.local/gef.py https://github.com/hugsy/gef/raw/master/gef.py
fi

# Prompt git user if not set
if [ "$(git config --global --get user.email)" = "" ]; then
    echo "Git user is not set. Please answer these."
    read -p "git config --global user.email " email
    git config --global user.email "$email"
    read -p "git config --global user.name " name
    git config --global user.name "$name"
fi
