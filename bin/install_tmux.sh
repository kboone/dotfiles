!/bin/bash

# Script for installing tmux on systems where you don't have root access.
# tmux will be installed in $KYLE_INSTALL_DIR/bin.
# It's assumed that wget and a C/C++ compiler are installed.

# exit on error
set -e

INSTALL_DIR=$KYLE_INSTALL_DIR

TMUX_VERSION=2.0

# create our directories
mkdir -p $INSTALL_DIR $INSTALL_DIR/tmux_tmp
cd $INSTALL_DIR/tmux_tmp

# download source files for tmux, libevent, and ncurses

wget -O tmux-${TMUX_VERSION}.tar.gz https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
wget -O libevent-2.0.19-stable.tar.gz https://github.com/libevent/libevent/archive/release-2.0.19-stable.tar.gz
wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz

# extract files, configure, and compile

############
# libevent #
############
tar xvzf libevent-2.0.19-stable.tar.gz
cd libevent-release-2.0.19-stable
./autogen.sh
./configure --prefix=$INSTALL_DIR --disable-shared
make
make install
cd ..

############
# ncurses  #
############
tar xvzf ncurses-5.9.tar.gz
cd ncurses-5.9
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
rm -rf $INSTALL_DIR/tmux_tmp

echo "$INSTALL_DIR/bin/tmux is now available."
