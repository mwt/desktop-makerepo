#!/bin/zsh
#===================================================
# This script generates the repositories
#===================================================

# To use with another project, change this string and reprepro/conf/distributions
REPO_API_URL="https://api.github.com/repos/shiftkey/desktop/releases"

# Get folder that this script is in
SCRIPT_DIR=${0:a:h}
REPO_DIR=${SCRIPT_DIR:h}

# Folder where we store downloads json and version file
STAGING_DIR="${REPO_DIR}/staging"

# Make a backlog of the same size as the limit
BACKLOG_SIZE="${1:-$(sed -n 's/Limit: \(.\+\)/\1/p' "${REPO_DIR}/reprepro/conf/distributions")}"

# Get function for creating deb/rpm repos
. "${REPO_DIR}/functions.zsh"


#===================================================
# Get Info About Latest Release
#===================================================

# Retreive json file describing latest release
wget -qO "${STAGING_DIR}/backlog.json" "${REPO_API_URL}?per_page=${BACKLOG_SIZE}" || (date_time_echo "json download failed"; exit 1)


#===================================================
# START Update
#===================================================

cd "${STAGING_DIR}"
make_repos -m "${STAGING_DIR}/backlog.json" "${REPO_DIR}/reprepro/conf" "${REPO_DIR}/dist/rpm"
