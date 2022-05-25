#!/bin/zsh

SCRIPT_DIR=${0:a:h}
REPO_DIR=${SCRIPT_DIR:h}

# create downloads folder
mkdir -p "$REPO_DIR/staging"

# replace gpg code if there is an argument
if [[ -z $1 ]] {
    echo "Install gpg key yourself"
} else {
    sed -i "s/^SignWith: .\+$/SignWith: $1/" "$REPO_DIR/reprepro/conf/distributions"
}

# create reprepro options file
cat << EOF > "$REPO_DIR/reprepro/conf/options"
basedir $REPO_DIR/dist/deb
dbdir $REPO_DIR/reprepro/db
logdir $REPO_DIR/reprepro/logs
EOF

# create folders for reprepro
mkdir -p "$REPO_DIR/reprepro/db/"
mkdir -p "$REPO_DIR/reprepro/logs/"
mkdir -p "$REPO_DIR/dist/deb/"

# create folder for yum repo
mkdir -p "$REPO_DIR/dist/rpm/"

# compile functions (not required)
zcompile "$REPO_DIR/functions.zsh"
