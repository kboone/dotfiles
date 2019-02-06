#!/bin/bash

# Script for installing cmake on systems where you don't have root access.
# cmake will be installed in $PACKAGE_DIR/cmake.
# We download the binary linux x64 installer which seems to work well. The
# source for cmake is massive.

# only accessible to me
umask 027

# exit on error
set -e

INSTALL_DIR=$PACKAGE_DIR/cmake
TEMP_BUILD_DIR=$INSTALL_DIR/build

# create our directories
mkdir -p $INSTALL_DIR $TEMP_BUILD_DIR
ORIG_DIR=$(pwd)
cd $TEMP_BUILD_DIR

wget https://cmake.org/files/v3.5/cmake-3.5.2-Linux-x86_64.sh \
    --no-check-certificate
chmod +x cmake-3.5.2-Linux-x86_64.sh
./cmake-3.5.2-Linux-x86_64.sh --prefix=$INSTALL_DIR --skip-license

# cleanup
cd $ORIG_DIR
rm -rf $TEMP_BUILD_DIR

echo "$INSTALL_DIR/bin/cmake is now available."
echo "Reload your bashrc with '. ~/.bashrc' to update your path."
