#!/bin/bash
# Script to install/update neovim plugins.
# This will also compile any plugins that need compiling.

# First, download newest versions of all plugins.
nvim -c PlugUpdate -c PlugUpgrade -c PlugClean! -c UpdateRemotePlugins -c quitall
