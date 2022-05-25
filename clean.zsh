#!/bin/zsh
#===================================================
# This script just deletes everything and reruns
#===================================================

SCRIPT_DIR=${0:a:h}

cd "${SCRIPT_DIR}"

# delete every file that is not tracked by the repo
git clean -dfx

# run the enviroment script
"${SCRIPT_DIR}/initial-setup/2-enviroment.zsh"
