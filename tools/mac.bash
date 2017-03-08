#!/bin/bash

CURRENT_DIR="$( cd "$( dirname $(readlink -e "${BASH_SOURCE[0]}") )" && pwd )"
source $CURRENT_DIR/common.bash

doit brew install tmux python python3 wget tree htop p7zip the_silver_searcher
doit brew install vim --with-python3
py23 requests virtualenv virtualenvwrapper jedi isort apsw

doit brew install qemu binwalk
py23 capstone pycrypto Pillow ply gmpy
py23 pwntools angr-only-z3-custom

doit brew install bash-completion
doit brew tap homebrew/completions
