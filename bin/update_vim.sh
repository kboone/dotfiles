#!/bin/bash
# Script to install/update vim plugins.
# This will also compile any plugins that need compiling.

# Load the vim anaconda
source activate vim

# First, download newest versions of all plugins.
vim -c PlugUpdate -c PlugUpgrade -c PlugClean! -c quitall

# Compile YouCompleteMe
cd $HOME/.vim/plugged/YouCompleteMe
PYTHON_LIB=$(ls $(python-config --prefix)/lib/libpython*.so)
PYTHON_INC=$(python-config --prefix)/include
EXTRA_CMAKE_ARGS="-DPYTHON_LIBRARY=$PYTHON_LIB \
    -DPYTHON_INCLUDE_DIRS=$PYTHON_INC" ./install.py

# Cleanup
source deactivate
