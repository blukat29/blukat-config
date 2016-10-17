#!/bin/bash

# installs docker to Ubuntu 12.04 / 14.04 / 16.04 LTS systems.

CURRENT_DIR="$( cd "$( dirname $(readlink -e "${BASH_SOURCE[0]}") )" && pwd )"
source $CURRENT_DIR/common.bash

doit sudo apt-get -y install apt-transport-https ca-certificates
doit sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual
doit sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

codename=$(lsb_release -c | cut -f 2)
apt_src="deb https://apt.dockerproject.org/repo ubuntu-$codename main"
echo $apt_src | sudo tee /etc/apt/sources.list.d/docker.list

doit sudo apt-get update
doit sudo apt-get -y install docker-engine
doit sudo docker run --rm hello-world
