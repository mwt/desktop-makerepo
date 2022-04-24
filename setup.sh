#!/bin/sh

sudo apt update && sudo apt install \
gzip gpg wget zsh \
jq \
dpkg apt-utils \
createrepo-c


# create downloads folder
mkdir ./staging

# create folder for apt repo
mkdir -p ./dist/deb/dists/any/main/binary-amd64/

# create folder for yum repo
mkdir -p ./dist/rpm/

echo "install gpg key manually"
