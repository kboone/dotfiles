#!/bin/bash

# Script for updating conda.
# This script sets up all the channels that I want and installs a good default
# set of packages that I use on all systems.
# Note that the current environment isn't changed, so this can be used to set
# up either the default environment or any newly created one.
#
# On some old science computers, the versions of libc and things like that are
# way out of date so some packages break (eg: iminuit). To resolve that, build
# a local conda package. I check for local packages in this script and don't
# overwrite them.
# Steps:
#   conda skeleton pypi --noarch-python iminuit
#   conda build iminuit
#   conda install --use-local iminuit
# This fails for sep. To fix, add numpy to the requirements in meta.yaml


# Make created files only accessible to me
umask 077

# Exit on error
set -e

# List of packages to install
PACKAGES=(
    # Core packages
    python
    ipython
    conda
    conda-build
    jupyter
    argcomplete
    beautifulsoup4
    pip

    # General coding packages
    flake8
    tqdm

    # Data science packages
    numpy
    scipy
    matplotlib
    pandas
    scikit-learn
    iminuit
    pystan

    # Astronomy packages
    astropy
    extinction
    sncosmo
    sep
    # not updated to python 3.6 yet... ugh. Omit for now until I need it.
    # pyephem
)

function ignore_packages {
    # Remove packages matching a given regex in conda list from the list of
    # packages to install. This is used to override updating manually installed
    # packaged.
    # Parameters are package name and conda list grep regex, 
    IGNORE_PACKAGES=($(conda list | grep "$2" | awk '{print $1 "=" $2}'))

    did_print=0
    
    for ignore_package in ${IGNORE_PACKAGES[@]}; do
        index=0
        for package in ${PACKAGES[@]}; do
            if [ "$package" = "${ignore_package%=*}" ]; then
                if [ "$did_print" -eq "0" ]; then
                    echo "WARNING: some $1 packages are installed. These" \
                        "will not be kept updated."
                    did_print=1
                fi
                echo " - $ignore_package"
                # Ugly. Set the object at the given index in the array to an
                # empty variable and then remake the array. There is probably a
                # better way of doing this.
                unset PACKAGES[$index]
                PACKAGES=(${PACKAGES[@]})
                break
            fi
            index=$((index+1))
        done
    done

    if [ $did_print -eq "1" ]; then
        echo ""
    fi
}

ignore_packages 'local' 'local$'
ignore_packages 'pip' '<pip>$'

# Update/install all packages that I want.
conda install ${PACKAGES[@]}
