#!/bin/sh

find $HOME/.vim/plugin/taglist.vim
if [ $? -eq 0 ]; then
  echo "taglist.vim already installed."
  exit 0
fi

if [ ! -d $HOME/.vim ]; then
  mkdir $HOME/.vim
fi
cd $HOME/.vim

wget -O taglist.zip http://www.vim.org/scripts/download_script.php?src_id=7701
unzip taglist.zip
rm taglist.zip

