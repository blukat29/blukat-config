#!/bin/bash

CURRENT_DIR="$( cd "$( dirname $(readlink -e "${BASH_SOURCE[0]}") )" && pwd )"
source $CURRENT_DIR/common.bash

# Install homebrew
if ! type brew; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Unlike others, these brew formulas emits error when it already exists.
brew_check_and_install () {
    formula="$1"
    if ! brew list | grep "$formula" >/dev/null ; then
        doit brew install "$formula"
    fi
}

# Vim with python3 support
if ! vim --version | grep "+python3" >/dev/null ; then
    doit brew install vim --with-python3
fi

# Python
doit brew install python
brew_check_and_install python3
py23 requests virtualenv virtualenvwrapper jedi isort apsw

# Command line tools
doit brew install tmux wget tree htop p7zip
doit brew install the_silver_searcher fzf
brew_check_and_install bash-completion
doit brew tap homebrew/completions

# Security tools
brew_check_and_install qemu
doit brew install binwalk
py23 capstone pycrypto Pillow ply gmpy
py23 pwntools angr-only-z3-custom
