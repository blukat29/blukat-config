#/bin/bash

# Collection of tools related to security tasks such as
# binary analysis, exploit writing and penetration testing.

CURRENT_DIR="$( cd "$( dirname $(readlink -e "${BASH_SOURCE[0]}") )" && pwd )"
source $CURRENT_DIR/common.bash

doit sudo apt install -y libffi-dev libssl-dev libpng-dev
doit sudo apt install -y binwalk
doit sudo apt install -y default-jdk

# Disallow non-root user to capture packets.
debconf-set-selections <<< 'wireshark-common wireshark-common/install-setuid boolean false'
doit sudo apt install -y tcpdump tshark

# install libcapstone
if ! ldconfig -p | grep libcapstone; then
    CAPSTONE_VERSION=3.0.4
    doit curl -L https://github.com/aquynh/capstone/archive/$CAPSTONE_VERSION.tar.gz -o /tmp/capstone-$CAPSTONE_VERSION.tar.gz
    doit cd /tmp && tar xf capstone-$CAPSTONE_VERSION.tar.gz
    doit cd /tmp/capstone-$CAPSTONE_VERSION && ./make.sh
    doit cd /tmp/capstone-$CAPSTONE_VERSION && sudo make install
fi

# install volatility
if ! type "vol.py" &> /dev/null; then
    VOLATILITY_VERSION=2.5
    doit curl -L https://github.com/volatilityfoundation/volatility/archive/$VOLATILITY_VERSION.tar.gz -o /tmp/volatility-$VOLATILITY_VERSION.tar.gz
    doit cd /tmp && tar xf volatility-$VOLATILITY_VERSION.tar.gz
    doit cd /tmp/volatility-$VOLATILITY_VERSION && sudo python2 setup.py install
fi

py23 capstone pycrypto distorm3 Pillow ply pwntools angr-only-z3-custom

