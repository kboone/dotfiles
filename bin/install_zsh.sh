#!/usr/bin/env bash

INSTALL_DIR=$HOME/.kyle_install

mkdir -p $INSTALL_DIR
cd $INSTALL_DIR

mkdir -p temp/zsh
cd temp/zsh
wget http://sourceforge.net/projects/zsh/files/zsh/5.0.6/zsh-5.0.6.tar.gz/download
tar -xvf *
cd zsh*

./configure --prefix=$INSTALL_DIR
make
make install
 
rm -rf $INSTALL_DIR/temp/zsh
