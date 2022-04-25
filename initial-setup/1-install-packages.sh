#!/bin/sh

## Basic dependencies:
#  - gzip: for thoroughness 
#  - gpg: sign repos
#  - wget: download json and packages
#  - zsh: build script is in zsh
#  - jq: process json files
#
## APT repos:
#  - dpkg: get version info for renaming
#  - apt-utils: contains apt-ftparchive
#
## YUM repos:
#  - rpm: get version info for renaming
#  - createrepo-c: make repo metadata
#

sudo apt update && sudo apt -y install \
gzip gpg wget zsh jq \
dpkg apt-utils \
rpm createrepo-c
