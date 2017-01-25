#!/bin/sh

# Based off of oh-my-zsh update script

#The MIT License

#Copyright (c) 2009-2014 Robby Russell and contributors (see
#https://github.com/robbyrussell/oh-my-zsh/contributors)

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

BASEDIR=$HOME/.dotfiles

function _current_epoch() {
    echo $(($(date +%s) / 60 / 60 / 24))
}

function _update_dotfiles_update() {
    echo "LAST_EPOCH=$(_current_epoch)" > ~/.dotfiles-update
}

function _upgrade_dotfiles() {
    echo "Upgrading dotfiles"
    ORIGDIR=$PWD
    cd $BASEDIR

    git pull
    echo "You may need to update symlinks, run 'dotfiles link' if so"

    # update the dotfiles file
    _update_dotfiles_update

    cd $ORIGDIR
}

epoch_target=$UPDATE_DOTFILES_DAYS
if [[ -z "$epoch_target" ]]; then
    # Default to old behavior
    epoch_target=13
fi

if [ -f ~/.dotfiles-update ]
then
    . ~/.dotfiles-update

    if [[ -z "$LAST_EPOCH" ]]; then
        _update_dotfiles_update && return 0;
    fi

    epoch_diff=$(($(_current_epoch) - $LAST_EPOCH))
    if [ $epoch_diff -gt $epoch_target ]
    then
        if [ "$DISABLE_UPDATE_PROMPT" = "true" ]
        then
            _upgrade_dotfiles
        else
            echo "[dotfiles] Would you like to check for updates?"
            echo "Type Y to update dotfiles: "
            read line
            if [ "$line" = Y ] || [ "$line" = y ]; then
                _upgrade_dotfiles
            else
                _update_dotfiles_update
            fi
        fi
    fi
else
  # create the dotfiles file
  _update_dotfiles_update
fi

# Add dotfiles as a command
alias dotfiles="$BASEDIR/bin/dotfiles"
