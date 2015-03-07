#!/bin/sh

head() {
  echo ""
  echo "\033[1;33m$1\033[0;0m"
}

info() {
  echo "\033[1;36m$1\033[0;0m"
}

warn() {
  echo "\033[1;31m$1\033[0;0m"
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

all_exists() {
  for name in $@
  do
    type $name >/dev/null
    if [ $? -ne 0 ]; then
      dpkg -l | grep "$name " >/dev/null
      if [ $? -ne 0 ]; then
        return "0"
      fi
    fi
  done
  return "1"
}

python_exists() {
  for name in $@
  do
    python -c "import $name" 2>/dev/null
    if [ $? -ne 0 ]; then
      return "0"
    fi
  done
  return "1"
}

apt_repo() {
  head "Change apt-get repository into kr.archive.ubuntu.com"
  info "  files affected: /etc/apt/sources.list"

  cat /etc/apt/sources.list | grep kr.archive.ubuntu.com >/dev/null
  if [ $? -eq 0 ]; then
    warn "  repo urls are already changed."
    return
  fi

  prompt
  if [ $? -eq 1 ]; then
    cd /etc/apt
    if [ ! -f sources.list.bak ]; then
      sudo cp sources.list sources.list.bak
    fi
    sudo awk -v OLD=us.archive.ubuntu.com \
        -v NEW=kr.archive.ubuntu.com \
        'BEGIN {count=0;}
         ($0 ~ OLD) {gsub(OLD, NEW); count++;}
         {print $0}
         END {print count " lines changed." > "/dev/stderr"}' \
        sources.list > sources.list.tmp
    sudo mv sources.list.tmp sources.list
    sudo apt-get update
    echo "done."
  fi
}

core_pkgs() {
  head "Install basic packages for dev. and hack."
  info "  pkgs installed: ctags gcc gdb make curl"
  info "                  build-essential autoconf"
  info "                  file zip unzip strace python-dev"

  all_exists ctags gcc gdb make curl build-essential
  if [ $? -eq 1 ]; then
    warn "  all of these are already installed."
    return
  fi

  prompt
  if [ $? -eq 1 ]; then
    sudo apt-get install ctags gcc gdb make curl \
                         build-essential autoconf \
                         file zip unzip strace python-dev
  fi
}

python_pip() {
  head "Install Python-pip and virtualenv"
  info "  dirs affected: /usr/lib/python2.7/*"

  all_exists pip virtualenv
  if [ $? -eq 1 ]; then
    warn "  pip and virtualenv are already installed."
    return
  fi

  prompt
  if [ $? -eq 1 ]; then
    cd ~
    wget https://bootstrap.pypa.io/get-pip.py
    sudo python get-pip.py
    rm get-pip.py
    sudo pip install virtualenv
  fi
}

pip_pkgs() {
  head "Install useful python packages"
  info "  dirs affected: ~/.local/"
  info "  pkgs installed: requests Pillow"

  all_exists pip
  if [ $? -ne 1 ]; then
    warn "  pip not installed. cannot install python packages."
    return
  fi

  python_exists requests PIL
  if [ $? -eq 1 ]; then
    warn "  all packages are already installed."
    return
  fi

  prompt
  if [ $? -eq 1 ]; then
    pip install requests
    pip install Pillow
  fi
}

setup_ntpd() {
  head "Setup NTP daemon to sync system time. (recommended in VM)."
  info "  packages installed: ntp"

  all_exists ntpd
  if [ $? -eq 1 ]; then
    warn "  ntpd already installed."
    return
  fi

  prompt
  if [ $? -eq 1 ]; then
    sudo apt-get -y install ntp
  fi
}

secure_tmp() {
  head "Change permissions of /tmp directory."
  info "  dirs affected: /tmp/*"

  if [ "`stat -c %a /tmp`" = "1773" ]; then
    warn "  /tmp permission is already set."
    return
  fi

  prompt
  if [ $? -eq 1 ]; then
    sudo chmod 1773 /tmp
    ls -al --color=always / | grep --color=none tmp
  fi
}

vbox_guest() {
  head "Install VirtualBox Guest Additions"
  info "  Click \"install guest addition\" before proceed"

  prompt
  if [ $? -eq 1 ]; then
    sudo mkdir -p /mnt/vboxcdrom
    sudo mount /dev/cdrom /mnt/vboxcdrom
    cd /mnt/vboxcdrom
    sudo ./VBoxLinuxAdditions.run
  fi
}

apt_repo
core_pkgs
python_pip
pip_pkgs
setup_ntpd
secure_tmp

head "Done!"

