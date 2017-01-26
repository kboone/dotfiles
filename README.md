# Kyle Boone's dotfiles

## How to install:

### Clone the git repository
    git clone --recursive git@github.com:kboone/dotfiles.git ~/.dotfiles

### Install (rerun if a new file is added)
# First time:
    ~/.dotfiles/bin/dotfiles link
    . ~/.bashrc

# Afterwards, dotfiles is added as a bash function.

### Install and update new packages as necessary
    dotfiles install vim
    dotfiles install conda
    dotfiles update vim

### Update if a submodule changed
    git submodule update --init --recursive

## Other things to do on a new server

### Set up ssh keys.
`scp -r .ssh ...` from somewhere. Make sure to get the
config right and stuff like that.

### Set up local things.
Edit `~/.bashrc_local` for things that don't need to be version
controlled. Temporary things should go here.
