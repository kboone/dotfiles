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

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

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
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
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

# Load my bashrc

# Kyle Boone's .bashrc
# This just does the things that I like specifically. Source this from the
# distro's main .bashrc using "source /data/.config/.bashrc".

# ssh aliases
alias sshphas='ssh -X kyle056@ssh.phas.ubc.ca'
alias ssheece='ssh -X w0e7@ssh.ece.ubc.ca'
alias sshat1='ssh -X kboone@atlasserv1.phas.ubc.ca'
alias sshat2='ssh -X kboone@atlasserv2.phas.ubc.ca'
alias sshat3='ssh -X kboone@atlasserv3.phas.ubc.ca'
alias sshat4='ssh -X kboone@atlasserv4.phas.ubc.ca'
alias sshat5='ssh -X kboone@atlasserv5.phas.ubc.ca'
alias sshat6='ssh -X kboone@atlasserv6.phas.ubc.ca'
alias sshat7='ssh -X kboone@atlasserv7.phas.ubc.ca'
alias sshat8='ssh -X kboone@atlasserv8.phas.ubc.ca'
alias sshat9='ssh -X kboone@atlasserv9.phas.ubc.ca'
alias sshat10='ssh -X kboone@atlasserv10.phas.ubc.ca'
alias sshat11='ssh -X kboone@atlasserv11.phas.ubc.ca'
alias sshpl='ssh -X plekaker@plekaker'
alias sshkb='ssh -X plekaker@kyleboone.ca'
alias sshlx='ssh -X kboone@lxplus.cern.ch'
alias sshhop='ssh -Y kboone@hopper.nersc.gov'
alias sshtop='ssh -Y kboone@topdog.lbl.gov'

# Add my custom install binaries.
# Note: do this last, so that we use the default if it is there (does this make
# sense?)
export PATH=$PATH:~/.kyle_install/bin

# fix terminal colors
export TERM='xterm-256color'        # BAD! Figure this out properly
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

#shopt -s checkwinsize

# Have the open command work in linux like in OSX
alias open='gnome-open'

echo $DISPLAY > ~/.display.txt
alias fix_display='export DISPLAY=`cat ~/.display.txt`'

# Check for dotfile upgrades
. ~/.dotfiles/tools/check_for_upgrade.sh

################################################################################
# Device specific setup.
################################################################################

if [[ "$HOSTNAME" == "julebrus" ]] || [[ "$HOSTNAME" == "troika" ]]; then
    # ROOT setup
    alias root='root -l'
    export PYTHONPATH=/usr/lib/x86_64-linux-gnu/root5.34:$PYTHONPATH
    export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/root5.34:$LD_LIBRARY_PATH
    # ROOTSYS is wrong but we need to specify something or we get a ton of
    # errors.
    export ROOTSYS=/usr/lib/x86_64-linux-gnu/root5.34

    # Anaconda - use python 3 by default
    export PATH="/data/apps/anaconda/bin:$PATH"
    #conda config --set changeps1 no
    #source activate py3k >/dev/null 2>&1

    alias block='sudo /data/apps/bin/block.sh'
    alias unblock='sudo /data/apps/bin/unblock.sh'

    # Add additional binaries in the data folder to the path
    export PATH=$PATH:/data/apps/bin
elif [[ "$HOSTNAME" == "topdog.lbl.gov" ]]; then
    # tmux, vim, etc.
    export PATH="/home/users/kboone/local/bin:$PATH"


    # hstsearcher
    export PATH="/home/users/kboone/anaconda/bin:$PATH"
    #export PATH="/home/users/kboone/hst/hstsearch/trunk/build/scripts-2.7:$PATH"

    export CLUSTERS="/home/scpdata05/clustersn"

    export HSTSEARCHDB="/home/users/kboone/hst/test_data/databases/test.db"
    export HSTSEARCHPATH="/home/users/kboone/hst/test_data/data/test/"

    export HSTFIELDPATH="/home/scpdata05/clustersn/fieldlists"
    export SEXPATH="/home/users/kboone/hst/hstsearch/trunk/hstsearch/sexfiles/"
    export iref="/home/scpdata05/clustersn/data/references/"

elif [[ "$HOSTNAME" == hopper* ]]; then
    # Aliases for different servers
    alias sshhop1='ssh hopper01'
    alias sshhop2='ssh hopper02'
    alias sshhop3='ssh hopper03'
    alias sshhop4='ssh hopper04'
    alias sshhop5='ssh hopper05'
    alias sshhop6='ssh hopper06'
    alias sshhop7='ssh hopper07'
    alias sshhop8='ssh hopper08'
    alias sshhop9='ssh hopper09'
    alias sshhop10='ssh hopper10'
    alias sshhop11='ssh hopper11'
    alias sshhop12='ssh hopper12'

    # Default to gnu compiler
    module swap PrgEnv-pgi PrgEnv-gnu 2>/dev/null
    module load gsl

    # Path
    export PATH=$PATH:~/local/bin
    export PATH=$PATH:~/scripts

    # Use Anaconda's python distribution
    export PATH=/global/homes/k/kboone/software/anaconda/bin:$PATH
    unset PYTHONPATH

    # SNFactory settings
    export PATH=/project/projectdirs/snfactry/rthomas/local/$NERSC_HOST/bin:$PATH

    # PyROOT settings
    module load root
    export PYTHONPATH=/usr/common/usg/root/5.34/gnu/lib/root:$PYTHONPATH
    export LD_LIBRARY_PATH=/usr/common/usg/root/5.34/gnu/lib/root:$LD_LIBRARY_PATH
fi
