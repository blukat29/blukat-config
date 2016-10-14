#!/bin/sh

mkdir -p "$HOME/.vim"
cd "$HOME/.vim"

ctags -R --c++-kinds=+p --fields=iaS --extra=+q \
    /usr/include \
    /usr/local/include
