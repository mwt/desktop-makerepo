#!/bin/sh

## Basic dependencies:
#  - sed: used to read a config file
#  - gpg: sign repos
#  - wget: download json and packages
#  - zsh: build script is in zsh
#  - jq: process json files
#  - git: to install reprepro
#
## APT repos:
#  - reprepro: makes apt repos (fork installed after)
#
## YUM repos:
#  - rpm: get version info for renaming
#  - createrepo-c: make repo metadata
#

mkdir -p ./temp/

# Download reprepro multiple versions
wget -O ./temp/reprepro.deb https://mattwthomas.com/gh/bin/reprepro-multiple-versions_5.3.0-1.4_amd64.deb

sudo apt-get update && sudo apt-get -y install \
zsh jq git \
rpm createrepo-c \
./temp/reprepro.deb

# don't allow reprepro to be updated from repos
sudo apt-mark hold reprepro

rm -r ./temp
