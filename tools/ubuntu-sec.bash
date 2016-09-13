#/bin/bash

# Collection of tools related to security tasks such as
# binary analysis, exploit writing and penetration testing.

CURRENT_DIR="$( cd "$( dirname $(readlink -e "${BASH_SOURCE[0]}") )" && pwd )"
source $CURRENT_DIR/common.bash

doit sudo apt install -y libffi-dev libssl-dev libpng-dev libgmp-dev
doit sudo apt install -y binwalk
doit sudo apt install -y default-jdk

# Disallow non-root user to capture packets.
debconf-set-selections <<< 'wireshark-common wireshark-common/install-setuid boolean false'
doit sudo apt install -y tcpdump tshark

# Update dynamic library status
doit sudo ldconfig

# install libcapstone
if ! ldconfig -p | grep libcapstone; then
    get_github_release aquynh capstone 3.0.4 out
    doit cd $out \
        && ./make.sh \
        && sudo make install
fi

# install libkeystone
if ! ldconfig -p | grep libkeystone; then
    get_github_release keystone-engine keystone 0.9.1 out
    cd $out \
        && mkdir -p build \
        && cd build \
        && ../make-share.sh \
        && sudo make install
fi

# install volatility
if ! type "vol.py" &> /dev/null; then
    get_github_release volatilityfoundation volatility 2.5 out
    cd $out \
        && sudo python setup.py install
fi

py23 capstone pycrypto distorm3 Pillow ply pwntools gmpy angr-only-z3-custom

