#!/bin/bash

# Script for installing vim on systems where you don't have root access.
# vim will be installed in $KYLE_INSTALL_DIR/bin.
# It's assumed that wget and a C/C++ compiler are installed.

# exit on error
set -e

INSTALL_DIR=$KYLE_INSTALL_DIR

# PYTHON_DIR=$KYLE_INSTALL_DIR/anaconda/lib/python2.7/config
# export LDFLAGS="-L$KYLE_INSTALL_DIR/anaconda/lib"

# create our directories
mkdir -p $INSTALL_DIR $INSTALL_DIR/vim_tmp
cd $INSTALL_DIR/vim_tmp

git clone https://github.com/vim/vim.git
cd vim

./configure --with-features=huge \
            --enable-multibyte \
            --enable-gui=gtk2 \
            --enable-luainterp \
            --enable-perlinterp \
            --enable-rubyinterp \
            --enable-cscope \
            --prefix=$INSTALL_DIR

# Try to get the various interpreters for free, but don't worry about it if
# they don't work. To really get python working properly, you need the
# following line set up:
# --with-python-config-dir=$PYTHON_DIR \

make
make install


# cleanup
rm -rf $INSTALL_DIR/vim_tmp

echo "$INSTALL_DIR/bin/vim is now available."
