#!/bin/zsh
#===================================================
# This script generates the repository
#===================================================

SCRIPT_DIR=$(pwd)

STAGING_DIR="$SCRIPT_DIR/staging"
DEB_REPO_DIR="$SCRIPT_DIR/dist/deb"
RPM_REPO_DIR="$SCRIPT_DIR/dist/rpm"

# Name of the gpg key
KEYNAME="B7BE5AC2"

# Get function for creating deb/rpm repos
source "$SCRIPT_DIR/functions.zsh"

# Retreive json file describing latest release
wget -qO "$STAGING_DIR/latest.json" "https://api.github.com/repos/shiftkey/desktop/releases/latest" || (echo "download failed"; exit 1)

# Get the new ID
LATEST_ID=$(jq -r '.id' "$STAGING_DIR/latest.json")

# jq -r '.id, (.assets[] | select(.content_type == "application/x-redhat-package-manager")| .browser_download_url )' "$STAGING_DIR/latest.json"

if [[ -f "$STAGING_DIR/version" ]] {
    if [[ $LATEST_ID == $(<$STAGING_DIR/version) ]] {
        echo "Already latest version"
        exit 0
    } else {
        echo "Updating to version $LATEST_ID"
    }
} else {
    echo "Adding version $LATEST_ID. No prior version found."
}

#===================================================
# START Update
#===================================================

cd $STAGING_DIR

# Get all download links (includes .AppImage)
DL_LINK_ARRAY=("${(f)"$(jq -r '.assets[] | .browser_download_url' "$STAGING_DIR/latest.json")"}")

for DL_LINK in ${DL_LINK_ARRAY}; {
    DL_FILE="${DL_LINK##*/}"
    if [[ "${DL_FILE}" == *.deb ]] {
        wget -N "${DL_LINK}"
        update_deb_repo "${DL_FILE}"
    } elif [[ "${DL_FILE}" == *.rpm ]] {
        wget -N "${DL_LINK}"
        update_rpm_repo "${DL_FILE}"
    }
}
