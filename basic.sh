#!/bin/bash

SCRIPT_DIR=$(dirname $0)

# Original dotfiles in home directory are copied into $BACKUP_DIR
if [ -z "$XDG_CONFIG_HOME" ]; then
  XDG_CONFIG_HOME="$HOME/.config"
fi
BACKUP_DIR=$XDG_CONFIG_HOME/config.bak.d
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
  NAME=$(basename $1)
  SOURCE="$SCRIPT_DIR/dotfiles/$1"

  if [ -z "$2" ]; then
    TARGET="$HOME/.$1"
  else
    TARGET="$2"
  fi
  TARGET_DIR=$(dirname "$TARGET")

  # Evict old file
  if [ -L $TARGET ]; then
    echo "Remove $TARGET"
    rm $TARGET
  elif [ -f $TARGET ]; then
    echo "Evict  $TARGET -> $BACKUP_DIR/$NAME"
    mv $TARGET $BACKUP_DIR/$NAME
  fi


  # Create symlink into dotfiles dir
  mkdir -p $(dirname $TARGET)
  ln -s $(relpath $SOURCE $TARGET_DIR) $TARGET
  echo "Link   $TARGET -> $SOURCE"
}

setup bashrc
setup vimrc
setup tmux.conf
setup gitconfig        $XDG_CONFIG_HOME/git/config
setup gitconfig.common $XDG_CONFIG_HOME/git/gitconfig.common
setup gitignore
setup gdbinit
setup inputrc
setup ctags

cp "$SCRIPT_DIR/dotfiles/bashrc.conf" "$HOME/.bashrc.conf"

# Install Vim-Plug
if [ ! -f ~/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
vim +PlugInstall +qall

# Install fzf auto completion
type "fzf" &> /dev/null
if [ $? -ne 0 ]; then
    git clone https://github.com/junegunn/fzf "$HOME/.config/fzf"
    "$HOME/.config/fzf/install" --no-update-rc --completion --key-bindings
    mv "$HOME/.fzf.bash" "$HOME/.config/.fzf.bash"
else
    echo "fzf already installed"
fi

# Prompt git user if not set
if [ "$(git config --global --get user.email)" = "" ]; then
    echo "Git user is not set. Please answer these."
    read -p "git config --global user.email " email
    git config --global user.email "$email"
    read -p "git config --global user.name " name
    git config --global user.name "$name"
fi
