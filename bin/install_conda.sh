#!/bin/bash

# Script for installing conda on systems where you don't have root access.
# conda will be installed in $PACKAGE_DIR/conda.
# I assume that wget and a C/C++ compiler are installed.

PYTHON_VERSION=3
CONDA_VERSION=latest

# only accessible to me
umask 027

# exit on error
set -e

INSTALL_DIR=$PACKAGE_DIR/conda
TEMP_BUILD_DIR=$PACKAGE_DIR/conda_temp

# Create our directories. Note that conda needs to create its directory
# itself, so we don't make that one.
mkdir -p $PACKAGE_DIR $TEMP_BUILD_DIR
ORIG_DIR=$(pwd)
cd $TEMP_BUILD_DIR

CONDA_SCRIPT=Miniconda${PYTHON_VERSION}-${CONDA_VERSION}-Linux-x86_64.sh

# Install conda and set up a default environment.
wget http://repo.continuum.io/miniconda/$CONDA_SCRIPT
bash $CONDA_SCRIPT -b -p $INSTALL_DIR

# Add the new conda to our path.
export PATH=$INSTALL_DIR/bin:$PATH

# Clean up.
cd $ORIG_DIR
rm -rf $TEMP_BUILD_DIR

echo "$INSTALL_DIR/conda is now available."
echo "Reload your bashrc with '. ~/.bashrc' to update your path."
