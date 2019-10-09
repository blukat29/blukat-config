#/bin/bash

# Collection of tools related to software development

CURRENT_DIR="$( cd "$( dirname $(readlink -e "${BASH_SOURCE[0]}") )" && pwd )"
source $CURRENT_DIR/common.bash

doit sudo apt update

# Build tools
# build-essential covers gcc, g++, libc6-dev, make, dpkg-dev.
doit sudo apt install -y build-essential gcc-multilib gdb \
    cmake autoconf automake libtool ninja-build
# Utilities
doit sudo apt install -y curl wget git zip p7zip \
    vim tmux exuberant-ctags silversearcher-ag bc \
    tree htop \
    sqlite3 libsqlite3-dev

# Python development
doit sudo apt install -y python-minimal python2.7 python3 python-dev python3-dev
if type "pip2" &> /dev/null || type "pip3" &> /dev/null; then
    msg "pip is already installed"
else
    doit curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
    doit sudo -H python2 /tmp/get-pip.py
    doit sudo -H python3 /tmp/get-pip.py
fi

# Python packages
py23 requests virtualenv virtualenvwrapper jedi isort flake8

