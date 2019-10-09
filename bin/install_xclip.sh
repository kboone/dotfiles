#!/bin/bash

# Script for installing xclip on systems where you don't have root access.
# xclip will be installed in $PACKAGE_DIR/xclip.

# only accessible to me
umask 027

# exit on error
set -e

INSTALL_DIR=$PACKAGE_DIR/xclip
TEMP_BUILD_DIR=$INSTALL_DIR/build

# create our directories
mkdir -p $INSTALL_DIR $TEMP_BUILD_DIR
ORIG_DIR=$(pwd)
cd $TEMP_BUILD_DIR

git clone git@github.com:astrand/xclip.git
cd xclip
autoreconf
./configure --prefix=$INSTALL_DIR
make
make install

# cleanup
cd $ORIG_DIR
rm -rf $TEMP_BUILD_DIR

echo "$INSTALL_DIR/bin/xclip is now available."
echo "Reload your bashrc with '. ~/.bashrc' to update your path."
