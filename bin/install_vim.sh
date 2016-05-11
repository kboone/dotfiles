#!/bin/bash

# Script for installing vim on systems where you don't have root access.
# vim will be installed in $PACKAGE_DIR/vim.
# We will link against a python anaconda environment with the name vim. That
# should be set up before this is run by running install_anaconda.sh. If you
# want to create the environment manually (eg: with miniconda), run:
# conda create --name vim anaconda python=2
# It's assumed that git and a C/C++ compiler are installed.

# only accessible to me
umask 077

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
ORIG_DIR=$(pwd)
cd $TEMP_BUILD_DIR

git clone https://github.com/vim/vim.git
cd vim

# Vim is annoying and puts the system python libs before the detected ones. By
# pointing it to the right ones with LDFLAGS, we can override that behaviour.
# We also need to set vi_cv_path_python so that vim picks up the anaconda
# python.
LDFLAGS="-L$(ls -d $(python-config --prefix)/lib/python*/config/)" \
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
cd $ORIG_DIR
rm -rf $TEMP_BUILD_DIR
source deactivate

echo "$INSTALL_DIR/bin/vim is now available."

# Reload our bashrc to pick up all the new binaries
. ~/.bashrc
