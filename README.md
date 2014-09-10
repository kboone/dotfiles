dotfiles
========

Kyle Boone's dotfiles

How to install:

# Clone the git repository
git clone --recursive git@github.com:kboone/dotfiles.git ~/.dotfiles

# Install (rerun if a new file is added)
cd ~/.dotfiles
bin/dotwarrior

# Update if a submodule changed
git submodule update --init --recursive
