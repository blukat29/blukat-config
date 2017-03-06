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
    get_github_release aquynh capstone 3.0.5-rc2 out
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
        && sudo make install \
        && cd ../binding/python \
        && sudo make install
fi

# install volatility
if ! type "vol.py" &> /dev/null; then
    get_github_release volatilityfoundation volatility 2.5 out
    cd $out \
        && sudo python setup.py install
fi

# install z3 for python3
python3 -c 'import z3' >/dev/null 2>/dev/null
if [ "$?" != "0" ]; then
    tmp_down=/tmp/z3.tar.gz
    doit curl -L https://github.com/Z3Prover/Z3/archive/z3-4.5.0.tar.gz -o $tmp_down \
        && cd /tmp && tar xf $tmp_down \
        && rm -f $tmp_down
    cd /tmp/z3-z3-4.5.0/ \
        && python3 scripts/mk_make.py --python \
        && cd build \
        && make -j2 \
        && sudo make install
fi

py23 capstone pycrypto distorm3 Pillow ply gmpy
py23 pwntools
doit sudo -H pip2 install angr-only-z3-custom
doit sudo -H pip2 install angr
