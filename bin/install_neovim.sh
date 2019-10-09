#!/bin/bash

# Script for installing neovim on systems where you don't have root access.
# tmux will be installed in $PACKAGE_DIR/neovim.

# only accessible to me
umask 027

# exit on error
set -e

INSTALL_DIR=$PACKAGE_DIR/neovim

TEMP_BUILD_DIR=$INSTALL_DIR/build

# create our directories
mkdir -p $INSTALL_DIR $TEMP_BUILD_DIR
ORIG_DIR=$(pwd)
cd $TEMP_BUILD_DIR

# download the latest stable appimage
wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage

# For now, extract the appimage since we work with a lot of old machines that don't
# support the FUSE mounting yet.
chmod +x ./nvim.appimage
./nvim.appimage --appimage-extract

# Move the appimage files to the installation directory.
mv squashfs-root/* $INSTALL_DIR/

# cleanup
cd $ORIG_DIR
rm -rf $TEMP_BUILD_DIR

echo "$INSTALL_DIR/usr/bin/nvim is now available."
echo "Reload your bashrc with '. ~/.bashrc' to update your path."
