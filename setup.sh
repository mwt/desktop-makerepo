#!/bin/sh

sudo apt update && sudo apt -y install \
gzip gpg wget zsh \
jq \
dpkg apt-utils \
rpm createrepo-c


# create downloads folder
mkdir -p ./staging

# create folder for apt repo
mkdir -p ./dist/deb/dists/any/main/binary-amd64/

# create folder for yum repo
mkdir -p ./dist/rpm/

echo "install gpg key manually"
