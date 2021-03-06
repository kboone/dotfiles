#!/bin/bash

# Script for installing tmux on systems where you don't have root access.
# tmux will be installed in $PACKAGE_DIR/tmux.
# It's assumed that wget and a C/C++ compiler are installed. We build libevent
# and ncurses manually to get recent versions.

echo "tmux can be installed via conda-forge now. Don't use this!"
exit 1

# only accessible to me
umask 027

# exit on error
set -e

INSTALL_DIR=$PACKAGE_DIR/tmux
TEMP_BUILD_DIR=$INSTALL_DIR/build

TMUX_VERSION=2.6

# create our directories
mkdir -p $INSTALL_DIR $TEMP_BUILD_DIR
ORIG_DIR=$(pwd)
cd $TEMP_BUILD_DIR

# download source files for tmux, libevent, and ncurses

wget -O tmux-${TMUX_VERSION}.tar.gz https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
wget -O libevent-2.1.8-stable.tar.gz https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz

# extract files, configure, and compile

############
# libevent #
############
tar xvzf libevent-2.1.8-stable.tar.gz
cd libevent-2.1.8-stable
./configure --prefix=$INSTALL_DIR --disable-shared
make
make install
cd ..

############
# ncurses  #
############
tar xvzf ncurses-6.0.tar.gz
cd ncurses-6.0
./configure --prefix=$INSTALL_DIR
make
make install
cd ..

############
# tmux     #
############
tar xvzf tmux-${TMUX_VERSION}.tar.gz
cd tmux-${TMUX_VERSION}
./configure CFLAGS="-I$INSTALL_DIR/include -I$INSTALL_DIR/include/ncurses" LDFLAGS="-L$INSTALL_DIR/lib -L$INSTALL_DIR/include/ncurses -L$INSTALL_DIR/include"
CPPFLAGS="-I$INSTALL_DIR/include -I$INSTALL_DIR/include/ncurses" LDFLAGS="-static -L$INSTALL_DIR/include -L$INSTALL_DIR/include/ncurses -L$INSTALL_DIR/lib" make
cp tmux $INSTALL_DIR/bin
cd ..

# cleanup
cd $ORIG_DIR
rm -rf $TEMP_BUILD_DIR

echo "$INSTALL_DIR/bin/tmux is now available."
echo "Reload your bashrc with '. ~/.bashrc' to update your path."
