# Kyle Boone's dotfiles

## How to install:

### Clone the git repository
    git clone --recursive git@github.com:kboone/dotfiles.git ~/.dotfiles

### Install (rerun if a new file is added)
    cd ~/.dotfiles
    bin/dotwarrior

### Update if a submodule changed
    git submodule update --init --recursive

### Download vim plugins using Vundle
Open vim. Run `:PluginInstall`

## Other things to do on a new server

### Set up ssh keys.
`scp -r .ssh ...` from somewhere. Make sure to get the
config right and stuff like that.

### Set up local things.
Edit `~/.bashrc_local` for things that don't need to be version
controlled. Temporary things should go here.
