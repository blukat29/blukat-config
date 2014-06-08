#!/bin/sh
if [ -f $HOME/.vimrc ]; then
    mv $HOME/.vimrc $HOME/.vimrc.old
fi
cp ./blukat.vimrc $HOME/.vimrc

if [ -f $HOME/.bashrc ]; then
    mv $HOME/.bashrc $HOME/.bashrc.old
fi
cp ./blukat.bashrc $HOME/.bashrc
source $HOME/.bashrc

if [ -f $HOME/.tmux.conf ]; then
    mv $HOME/.tmux.conf $HOME/.tmux.conf.old
fi
cp ./blukat.tmux.conf $HOME/.tmux.conf

type -a tmux
if [ $? != 0 ]; then
  echo "tmux is not installed. run \"sh tmux_local_install.sh\""
fi

if [ ! -d "$HOME/.vim/bundle" ]; then
  echo "installing Vundle.vim ..."
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

echo "Config complete. Undo using unconfig-blukat.sh"
