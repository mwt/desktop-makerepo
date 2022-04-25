#!/bin/zsh

SCRIPT_DIR=${0:a:h}

# cd to main repo dir
cd "${SCRIPT_DIR}/.."

# create downloads folder
mkdir -p ./staging

# create folder for apt repo
mkdir -p ./dist/deb/dists/any/main/binary-amd64/

# create folder for yum repo
mkdir -p ./dist/rpm/

# compile functions (not required)
zcompile ./functions.zsh

# undo cd
cd -

echo "Install gpg key yourself"
