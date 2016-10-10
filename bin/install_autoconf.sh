#!/bin/bash

# Script for installing autoconf on systems where you don't have root access.
# autoconf will be installed in $PACKAGE_DIR/autoconf.

# only accessible to me
umask 077

# exit on error
set -e

INSTALL_DIR=$PACKAGE_DIR/autoconf
TEMP_BUILD_DIR=$INSTALL_DIR/build

# create our directories
mkdir -p $INSTALL_DIR $TEMP_BUILD_DIR
ORIG_DIR=$(pwd)
cd $TEMP_BUILD_DIR

wget http://ftp.gnu.org/gnu/autoconf/autoconf-latest.tar.gz
tar -xvf autoconf-latest.tar.gz
cd autoconf-*

./configure --prefix=$INSTALL_DIR

make
make install

# cleanup
cd $ORIG_DIR
rm -rf $TEMP_BUILD_DIR

echo "$INSTALL_DIR/bin/autoconf is now available."
echo "Reload your bashrc with '. ~/.bashrc' to update your path."
