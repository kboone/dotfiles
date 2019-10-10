#!/bin/bash
# Script to install/update vim plugins.
# This will also compile any plugins that need compiling.

# First, download newest versions of all plugins.
vim -c PlugUpdate -c PlugUpgrade -c PlugClean! -c BlackUpgrade -c quitall
