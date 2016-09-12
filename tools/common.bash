#/bin/bash

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

py23 () {
    doit sudo -H pip2 install $*
    doit sudo -H pip3 install $*
}

