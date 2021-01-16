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


# Make created files only accessible to me
umask 027

# Exit on error
set -e

# List of packages to install
PACKAGES=(
    # Core python packages
    python
    ipython
    conda
    conda-build
    cython
    argcomplete
    beautifulsoup4
    pip

    # Utilities
    glances

    # Coding packages
    pynvim
    tmux
    vim
    flake8
    git

    # Base data science packages
    numpy
    scipy
    matplotlib
    pandas
    iminuit
    pytables
    tqdm

    # Jupyter and dependencies
    jupyter
    jupyterlab
    nodejs
    h5py
    ipywidgets
    ipympl

    # Machine learning/statistics packages
    scikit-learn
    lightgbm
    george
    pystan
    pytorch

    # Documentation
    sphinx
    sphinx_rtd_theme
    numpydoc

    # Astronomy packages
    astropy
    extinction
    sncosmo
    sep
)

# Pip packages to install. Only do this if the package isn't on conda!
PIP_PACKAGES=(
    jupyterlab_vim
)

# List of JupyterLab packages to install
JUPYTERLAB_PACKAGES=(
    @jupyter-widgets/jupyterlab-manager
    @jupyterlab/toc
    @axlair/jupyterlab_vim
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
ignore_packages 'develop' '<develop>$'

# Update/install all conda packages that I want.
conda install --update-all "${PACKAGES[@]}"

# Pip packages
pip install --no-deps "${PIP_PACKAGES[@]}"