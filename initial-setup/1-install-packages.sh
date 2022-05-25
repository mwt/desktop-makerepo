#!/bin/sh

## Basic dependencies:
#  - sed: used to read a config file
#  - gpg: sign repos
#  - wget: download json and packages
#  - zsh: build script is in zsh
#
## YUM repos:
#  - rpm: get version info for renaming
#

DEPS="sed gpg wget git rpm"

# if option set, setup the bundled zsh
if [ "$1" = "--bundle-zsh" ]; then
    # store repo root as variable
    REPO_ROOT="$(readlink -f $(dirname $(dirname $0)))"
    # relocate the zsh binary (romkatv/zsh-bin)
    "$REPO_ROOT/usr/share/zsh/5.8/scripts/relocate" -s "$REPO_ROOT/usr" -d "$REPO_ROOT/usr"

    ZSH_PATH="$REPO_ROOT/usr/bin/zsh"
    find $REPO_ROOT -type f -name "*.zsh" -exec sed -i "s|^#!.\+$|#!${ZSH_PATH}|" '{}' \;

    if command -v apt-get > /dev/null; then
        sudo apt-get update && 
        sudo apt-get -y install $DEPS
    else
        echo "This script expects apt. Please manually install $DEPS"
        exit 1
    fi
else
    # if the option is not set, add zsh to deps
    DEPS="$DEPS zsh"
    if command -v apt-get > /dev/null; then
        sudo apt-get update && 
        sudo apt-get -y install $DEPS
    else
        echo "This script expects apt. Please manually install $DEPS"
        exit 1
    fi
fi
