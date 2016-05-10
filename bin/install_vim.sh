#!/bin/bash

# Script for installing vim on systems where you don't have root access.
# vim will be installed in $PACKAGE_DIR/vim.
# We will link against a python anaconda environment with the name vim. That
# should be set up before this is run with:
# conda create --name vim anaconda python=2
# It's assumed that wget and a C/C++ compiler are installed.

# exit on error
set -e

INSTALL_DIR=$PACKAGE_DIR/vim
TEMP_BUILD_DIR=$INSTALL_DIR/build

# Figure out which python to use. We want to use python from an anaconda
# environment with the name "vim"
source activate vim
VIM_PYTHON=$(which python)

# create our directories
mkdir -p $INSTALL_DIR $TEMP_BUILD_DIR
cd $TEMP_BUILD_DIR

git clone https://github.com/vim/vim.git
cd vim

vi_cv_path_python=$VIM_PYTHON \
./configure --with-features=huge \
            --enable-multibyte \
            --enable-gui=gtk2 \
            --enable-luainterp \
            --enable-perlinterp \
            --enable-rubyinterp \
            --enable-pythoninterp \
            --enable-cscope \
            --prefix=$INSTALL_DIR

make
make install


# cleanup
rm -rf $TEMP_BUILD_DIR

echo "$INSTALL_DIR/bin/vim is now available."
