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

get_github_release () {
    # Usage:   get_github_release <user> <repo> <ver> <outvar>
    # Example: get_github_release aquynh capstone 3.0.4
    # Effect:  downloads https://github.com/<user>/<repo>/archive/<ver>.tar.gz
    #          under /tmp and extracts to <repo>-<ver>
    #          It returns the extracted path to $<outvar>

    user=$1
    repo=$2
    ver=$3
    out=$4
    tmp_down=/tmp/blukat_config_tools.tar.gz

    doit curl -L https://github.com/$user/$repo/archive/$ver.tar.gz -o $tmp_down
    cd /tmp && tar xf $tmp_down
    rm -f $tmp_down
    eval "$4='/tmp/$repo-$ver'"
}

