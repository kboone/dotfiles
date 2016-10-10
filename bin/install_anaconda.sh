#!/bin/bash

# Script for installing anaconda on systems where you don't have root access.
# anaconda will be installed in $PACKAGE_DIR/anaconda.
# conda create --name vim anaconda python=2
# It's assumed that wget and a C/C++ compiler are installed.

PYTHON_VERSION=2
ANACONDA_VERSION=4.0.0

# only accessible to me
umask 077

# exit on error
set -e

INSTALL_DIR=$PACKAGE_DIR/anaconda
TEMP_BUILD_DIR=$PACKAGE_DIR/anaconda_temp

# Create our directories. Note that anaconda needs to create its directory
# itself, so we don't make that one.
mkdir -p $PACKAGE_DIR $TEMP_BUILD_DIR
ORIG_DIR=$(pwd)
cd $TEMP_BUILD_DIR

ANACONDA_SCRIPT=Anaconda${PYTHON_VERSION}-${ANACONDA_VERSION}-Linux-x86_64.sh

# Install anaconda and set up a default environment
wget http://repo.continuum.io/archive/$ANACONDA_SCRIPT
bash $ANACONDA_SCRIPT -b -p $INSTALL_DIR

# Add the new anaconda to our path
export PATH=$INSTALL_DIR/bin:$PATH

# Set up a vim envirionment
conda create --name vim anaconda python=2 -y

# cleanup
cd $ORIG_DIR
rm -rf $TEMP_BUILD_DIR

echo "$INSTALL_DIR/anaconda is now available."
echo "Reload your bashrc with '. ~/.bashrc' to update your path."
