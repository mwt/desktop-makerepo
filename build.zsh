#!/bin/zsh
#===================================================
# This script generates the repository
#===================================================

SCRIPT_DIR=${0:a:h}

STAGING_DIR="${SCRIPT_DIR}/staging"
DEB_REPO_DIR="${SCRIPT_DIR}/dist/deb"
RPM_REPO_DIR="${SCRIPT_DIR}/dist/rpm"

# Name of the gpg key
KEYNAME="B7BE5AC2"

# Get function for creating deb/rpm repos
source "${SCRIPT_DIR}/functions.zsh"

# Retreive json file describing latest release
wget -qO "${STAGING_DIR}/latest.json" "https://api.github.com/repos/shiftkey/desktop/releases/latest" || (echo "json download failed"; exit 1)

# Get the new ID
LATEST_ID=$(jq -r '.id' "${STAGING_DIR}/latest.json")

if [[ -f "${STAGING_DIR}/version" ]] {
    if [[ ${LATEST_ID} == $(<$STAGING_DIR/version) ]] {
        echo "Already latest version"
        exit 0
    } else {
        echo "Updating to version ${LATEST_ID}"
    }
} else {
    echo "Adding version ${LATEST_ID}. No prior version found."
}

#===================================================
# START Update
#===================================================


# Get all download links (includes .AppImage)
DL_LINK_ARRAY=("${(f)"$(jq -r '.assets[] | .browser_download_url' "$STAGING_DIR/latest.json")"}")

for DL_LINK in ${DL_LINK_ARRAY}; {
    cd $STAGING_DIR
    DL_FILE="${DL_LINK##*/}"
    if [[ "${DL_FILE}" == *.deb ]] {
        wget -nv "${DL_LINK}" || (echo "deb download failed"; exit 1)
        update_deb_repo "${DL_FILE}" "${DEB_REPO_DIR}" "${KEYNAME}" "${SCRIPT_DIR}/apt-ftparchive.conf"
    } elif [[ "${DL_FILE}" == *.rpm ]] {
        wget -nv "${DL_LINK}" || (echo "rpm download failed"; exit 1)
        update_rpm_repo "${DL_FILE}" "${RPM_REPO_DIR}" "${KEYNAME}"
    }
}

# Write version number so that the loop will not repeat until a new version is released
echo "${LATEST_ID}" > "${STAGING_DIR}/version"
