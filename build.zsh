#!/bin/zsh
#===================================================
# This script generates the repositories
#===================================================

# To use with another project, change this string and reprepro/conf/distributions
REPO_LATEST_API="https://api.github.com/repos/shiftkey/desktop/releases/latest"

# Get folder that this script is in
SCRIPT_DIR=${0:a:h}

# Use packaged binaries if possible
PATH="$SCRIPT_DIR/usr/bin:$PATH"

# Folder where we store downloads json and version file
STAGING_DIR="${SCRIPT_DIR}/staging"

# Get function for creating deb/rpm repos
. "${SCRIPT_DIR}/functions.zsh"

# exit on first error
set -e

#===================================================
# Get Info About Latest Release
#===================================================

# Retreive json file describing latest release
wget -qO "${STAGING_DIR}/latest.json" "${REPO_LATEST_API}" || {date_time_echo "json download failed"; exit 1}

# Get the new ID
LATEST_ID=$(jq -r '.id' "${STAGING_DIR}/latest.json")

# Only continue if the latest release ID is different from the ID in staging/version
if [[ -f "${STAGING_DIR}/version" ]] {
    if [[ "${LATEST_ID}" == $(<"${STAGING_DIR}/version") ]] {
        date_time_echo "Already latest version (${LATEST_ID}).\n"
        exit 0
    } else {
        date_time_echo "Adding version ${LATEST_ID}."
    }
} else {
    date_time_echo "Adding version ${LATEST_ID}. No prior version found."
}


#===================================================
# START Update
#===================================================

cd "${STAGING_DIR}"
make_repos "${STAGING_DIR}/latest.json" "${SCRIPT_DIR}/reprepro/conf" "${SCRIPT_DIR}/dist/rpm" || exit 1


#===================================================
# POST Update
#===================================================

# Write version number so that the loop will not repeat until a new version is released
echo "${LATEST_ID}" > "${STAGING_DIR}/version" && 
date_time_echo "Current version is now ${LATEST_ID}!\n"
