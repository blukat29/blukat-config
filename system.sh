#!/bin/sh

head() {
  echo ""
  echo "\033[1;33m$1\033[0;0m"
}

info() {
  echo "\033[1;36m$1\033[0;0m"
}

prompt() {
  while true; do
    read -p "  continue? [y/n] " yn
    case $yn in
      [yY] ) return "1";;
      [nN] ) return "0";;
      * ) echo "Please answer y or n.";;
    esac
  done
}

apt_repo() {
  head "Change apt-get repository into kr.archive.ubuntu.com"
  info "  files affected: /etc/apt/sources.list"
  prompt
  if [ $? -eq 1 ]; then
    cd /etc/apt
    sudo cp sources.list sources.list.bak
    awk -v OLD=us.archive.ubuntu.com \
        -v NEW=kr.archive.ubuntu.com \
        'BEGIN {count=0;}
         ($0 ~ OLD) {gsub(OLD, NEW); count++;}
         END {print count " lines changed." > "/dev/stderr"}' \
        sources.list > sources.list.tmp
    mv sources.list.tmp sources.list
    echo "done."
  fi
}

python_pip() {
  head "Install Python-pip and virtualenv"
  info "  dirs affected: /usr/lib/python2.7/*"
  prompt
  if [ $? -eq 1 ]; then
    cd ~
    wget https://bootstrap.pypa.io/get-pip.py
    sudo python get-pip.py
    rm get-pip.py
    sudo pip install virtualenv
  fi
}

setup_ntpd() {
  head "Setup NTP daemon to sync system time. (recommended in VM)."
  info "  packages installed: ntp"
  info "  files affected: /etc/ntp.conf"
  prompt
  if [ $? -eq 1 ]; then
    sudo apt-get -y install ntp
  fi
}

apt_repo
python_pip
setup_ntpd

head "Done!"

