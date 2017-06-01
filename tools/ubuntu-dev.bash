#/bin/bash

# Collection of tools related to software development

CURRENT_DIR="$( cd "$( dirname $(readlink -e "${BASH_SOURCE[0]}") )" && pwd )"
source $CURRENT_DIR/common.bash

doit sudo apt update
# build-essential covers gcc, g++, libc6-dev, make, dpkg-dev.
doit sudo apt install -y build-essential gcc-multilib gdb
# Advanced build tools
doit sudo apt install -y cmake autoconf automake libtool
# Utilities
doit sudo apt install -y curl wget git zip p7zip
doit sudo apt install -y vim vim-nox-py2 tmux exuberant-ctags silversearcher-ag bc
doit sudo apt install -y tree htop
doit sudo apt install -y sqlite3 libsqlite3-dev
# Python development
doit sudo apt install -y python-minimal python2.7 python3 python-dev python3-dev
if type "pip" &> /dev/null; then
    msg "pip is already installed"
else
    doit curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
    doit sudo -H python2 /tmp/get-pip.py
    doit sudo -H python3 /tmp/get-pip.py
fi
# Python packages
py23 requests virtualenv virtualenvwrapper jedi isort flake8
# fzf auto completion
if type "fzf" &> /dev/null; then
    msg "fzf is already installed"
else
    doit git clone https://github.com/junegunn/fzf "$HOME/.config/fzf"
    doit "$HOME/.config/fzf/install" --no-update-rc --completion --key-bindings
    doit mv "$HOME/.fzf.bash" "$HOME/.config/.fzf.bash"
fi
