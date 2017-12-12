#!/bin/bash

# installs docker to Ubuntu 12.04 / 14.04 / 16.04 LTS systems.

CURRENT_DIR="$( cd "$( dirname $(readlink -e "${BASH_SOURCE[0]}") )" && pwd )"
source $CURRENT_DIR/common.bash

doit sudo apt-get -y install apt-transport-https ca-certificates
doit sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual
doit curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

doit sudo apt-get update
doit sudo apt-get -y install docker-ce
doit sudo docker run --rm hello-world
