#!/usr/bin/env bash
# Thanks to @samsonjs for the cleaned up version:
# https://gist.github.com/samsonjs/4076746

echo "This script is horribly out of date! Needs to be updated!"
exit 1

INSTALL_DIR=$KYLE_INSTALL_DIR
VERSION=1.2.4

# create our directories
mkdir -p $INSTALL_DIR $INSTALL_DIR/mosh_tmp
cd $INSTALL_DIR/mosh_tmp

# Install Protocol Buffers
wget http://protobuf.googlecode.com/files/protobuf-2.4.1.tar.bz2
tar -xf protobuf-2.4.1.tar.bz2 
cd protobuf-2.4.1
./configure --prefix=$INSTALL_DIR
make
make install
cd ..

## You'll need this setting to have mosh find the Protocol Buffer lib
export PKG_CONFIG_PATH=$INSTALL_DIR/lib/pkgconfig

# Install mosh
git clone git@github.com:keithw/mosh.git
cd mosh/
./autogen.sh
./configure --prefix=$INSTALL_DIR
make
make install

echo You can run this to verify the install worked:
echo   $ export LD_LIBRARY_PATH=$INSTALL_DIR/lib
echo   $ mosh-server
echo Running mosh-server should give you a pid and a key to use if you want to connect manually

# cleanup
rm -rf $INSTALL_DIR/mosh_tmp

echo To connect to the server in the future, run this on your local machine:
echo   $ mosh --server="LD_LIBRARY_PATH=$INSTALL_DIR/lib $INSTALL_DIR/bin/mosh-server" $USER@$(hostname -f)
