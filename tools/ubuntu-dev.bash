#/bin/bash

# Collection of tools related to software development

msg () {
    echo -e "\033[1;32m$1\033[0;m"
}

doit () {
    msg "$*"
    $*
    if [ $? -ne 0 ]; then
        echo -e "\033[1;31m$* was not successful.\033[0;m"
        exit 1
    fi
}

doit sudo apt update
# build-essential covers gcc, g++, libc6-dev, make, dpkg-dev.
doit sudo apt install -y build-essential gcc-multilib gdb
# Advanced build tools
doit sudo apt install -y cmake autoconf automake libtool
doit sudo apt install -y curl wget git
doit sudo apt install -y vim tmux exuberant-ctags
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
PYTHON_PACKAGES="requests virtualenv virtualenvwrapper jedi isort apsw"
doit sudo -H pip2 install --upgrade $PYTHON_PACKAGES
doit sudo -H pip3 install --upgrade $PYTHON_PACKAGES

