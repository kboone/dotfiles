# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Disable ctrl-s and ctrl-q remapping to some weird disabling output feature.
# This allows us to do ctrl-s for incremental i-search (like ctrl-r, but
# forwards)
stty -ixon

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Have the open command work in linux like in OSX
if [[ -n $(which xdg-open 2>/dev/null) ]]; then
    alias open='xdg-open'
elif [[ -n $(which gnome-open 2>/dev/null) ]]; then
    alias open='gnome-open'
fi

# We want to use the en_US.UTF-8 locale. Unfortunately, it is called en_US.utf8
# on SL6 machines. Detect which one is available and use it.
if [ -n "$(locale -a | grep '^en_US.UTF-8')" ]; then
    # On most new systems, this is available so use it.
    export LANG="en_US.UTF-8"
elif [ -n "$(locale -a | grep '^en_US.utf8')" ]; then
    # Resort to this if the newer one isn't available
    export LANG="en_US.utf8"
else
    # No UTF-8 locale found. This will mess up stuff
    echo "No UTF-8 locale found! Keeping default. No UTF-8 support."
fi

export LC_ALL=$LANG

# tmux breaks things like the display and ssh forwarding when you reconnect. Run
# fix_tmux in a tmux shell to solve all of these problems and get the
# environment properly set up when reconnecting.
fix_tmux() {
    eval $(tmux show-environment | sed "s/\(.*\)=\(.*\)/export \1=\"\2\"/" \
        | sed "s/^-/unset /")
}

# Grep in a versioned directory
vgrep() {
    grep --color=always -rn "$1" . | grep -v tags | grep -v \.svn \
        | grep -v \.git | grep -v pyc | grep -v \.egg-info
}

# Use vim as my default editor for svn and things.
export VISUAL=vim
export EDITOR=$VISUAL

# Set colorscheme
if [[ -f "$HOME/.dotfiles/packages/terminal_colors/set_colorscheme.sh" ]]; then
    . $HOME/.dotfiles/packages/terminal_colors/set_colorscheme.sh
fi

# Check for dotfile upgrades
. $HOME/.dotfiles/tools/check_for_upgrade.sh

# Default custom binaries install path. This gets added to path below, but I
# change it for some individual systems (eg: NERSC since all machines share the
# same home directory)
export KYLE_INSTALL_DIR=$HOME/.kyle_install

# Path for custom packages.
export PACKAGE_DIR=$HOME/packages

# Unset whatever the default PYTHONPATH is since I will be using anaconda
# instead.
unset PYTHONPATH

################################################################################
# Device specific setup.
################################################################################

if [[ "$HOSTNAME" == "troika" ]]; then
    # ROOT setup
    alias root='root -l'
    export PYTHONPATH=/usr/lib/x86_64-linux-gnu/root5.34:$PYTHONPATH
    export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/root5.34:$LD_LIBRARY_PATH
    # ROOTSYS is wrong but we need to specify something or we get a ton of
    # errors.
    export ROOTSYS=/usr/lib/x86_64-linux-gnu/root5.34

    alias block='sudo /data/apps/bin/block.sh'
    alias unblock='sudo /data/apps/bin/unblock.sh'

    # Add additional binaries in the data folder to the path
    export PATH=$PATH:/data/apps/bin
    
    # iraf
    ur_setup() {
        eval `/home/kyle/.ureka/ur_setup -sh $*`
    }
    ur_forget() {
        eval `/home/kyle/.ureka/ur_forget -sh $*`
    }
elif [[ "$HOSTNAME" == "julebrus" ]]; then
    export PATH="$HOME/apps/anaconda/bin:$PATH"
    export PATH="$HOME/apps/mathematica/bin:$PATH"
    export PATH="$HOME/apps/scripts:$PATH"

    # ureka
    ur_setup() {
        eval `/home/kyle/.ureka/ur_setup -sh $*`
    }
    ur_forget() {
        eval `/home/kyle/.ureka/ur_forget -sh $*`
    }
elif [[ "$HOSTNAME" == "zacharys.lbl.gov" ]] || [[ "$HOSTNAME" == "topdog.lbl.gov" ]]; then
    # Everything is currently installed here... change this to .kyle_install at
    # some point
    export KYLE_INSTALL_DIR=$HOME/local

    # my anaconda
    export ANACONDA=/home/users/kboone/anaconda
    export PATH=$ANACONDA/bin:$PATH

    # seechange
    source /home/scpdata05/clustersn/local/scripts/setup_seechange.sh
elif [[ "$HOSTNAME" == "rivoli.lbl.gov" ]]; then
    # seechange
    source /home/scpdata05/clustersn/local/scripts/setup_seechange.sh
elif [[ -n "$NERSC_HOST" ]]; then
    # We are on a NERSC machine (hopper, edison, etc.)

    # Load the gcc compiler. This is done differently on all of the machines.
    if [[ "$NERSC_HOST" == "carver" ]]; then
        module load gcc
        module load openmpi-gcc
    elif [[ "$NERSC_HOST" == "hopper" ]]; then
        module swap PrgEnv-pgi PrgEnv-gnu 2>/dev/null
    elif [[ "$NERSC_HOST" == "edison" ]]; then
        module swap PrgEnv-intel PrgEnv-gnu 2>/dev/null
    else
        echo "Unknown NERSC host, gcc not loaded!"
    fi

    # Custom install directory for the different servers
    export KYLE_INSTALL_DIR=$HOME/.kyle_install/$NERSC_HOST
        
    # Other modules to load that are on all of the NERSC machines. I want newer
    # versions of most things, but I don't care about the exact version number.
    module load gsl
    module load autoconf

    # Path
    export PATH=$PATH:$HOME/scripts

    # Use Anaconda's python distribution
    if [[ "$NERSC_HOST" == "cori" ]]; then
        export ANACONDA=$KYLE_INSTALL_DIR/anaconda
        export PATH=$ANACONDA/bin:$PATH
    else
        export PATH=/global/homes/k/kboone/software/anaconda/bin:$PATH
    fi
    unset PYTHONPATH

    # SNFactory settings
    export PATH=/project/projectdirs/snfactry/rthomas/local/$NERSC_HOST/bin:$PATH

    # Get a newer vim running
    module load vim

    # Load root, and set up things so that PyROOT works properly. This might
    # need to be updated.
    module load root
    export PYTHONPATH=/usr/common/usg/root/5.34/gnu/lib/root:$PYTHONPATH
    export LD_LIBRARY_PATH=/usr/common/usg/root/5.34/gnu/lib/root:$LD_LIBRARY_PATH
fi

# Add the custom install directory to my path.
export PATH=$KYLE_INSTALL_DIR/bin:$PATH

# Add any custom package directories to my path.
for i in $(shopt -s nullglob; echo $PACKAGE_DIR/*/bin); do
    export PATH=$i:$PATH
done

# Optional external bashrc file for local unversioned things
if [[ -f "$HOME/.bashrc_local" ]]; then
    . $HOME/.bashrc_local
fi

# Remove unexecutable directories from my path. Some servers are dumb, and git
# breaks when these are in it.
PATH=$(for d in ${PATH//:/ } ; do [ -x $d ] && printf "$d\n"; done \
    | uniq | tr '\n' ':')
export PATH=${PATH%?}
