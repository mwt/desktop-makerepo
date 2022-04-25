#===================================================
# Function for DEB Repo
#===================================================

update_deb_repo() {
    DEB_FILE="$1"
    DEB_REPO_DIR="$2"
    KEYNAME="$3"
    FTPARCHIVE_CONF="$4"

    PKG_VERSION=$(dpkg -f "${DEB_FILE}" Version)
    PKG_NAME=$(dpkg -f "${DEB_FILE}" Package)
    echo "Copying $DEB_FILE to $DEB_REPO_DIR/pool/${PKG_NAME:0:1}/${PKG_NAME}/${PKG_NAME}_${PKG_VERSION}_amd64.deb" 
    mkdir -p "${DEB_REPO_DIR}/pool/${PKG_NAME:0:1}/${PKG_NAME}/"
    cp "${DEB_FILE}" "${DEB_REPO_DIR}/pool/${PKG_NAME:0:1}/${PKG_NAME}/${PKG_NAME}_${PKG_VERSION}_amd64.deb"
    
    #===================================================
    # MAKE REPO
    #===================================================
    
    cd "${DEB_REPO_DIR}"
    # Make package file for all packages
    apt-ftparchive --arch amd64 packages ./pool/ | tee ./dists/any/main/binary-amd64/Packages | gzip > ./dists/any/main/binary-amd64/Packages.gz
    # Make Release file for all
    apt-ftparchive --arch amd64 release -c "${FTPARCHIVE_CONF}" ./dists/any/ > ./dists/any/Release
    cd -
    
    DISTS_ANY="${DEB_REPO_DIR}/dists/any"
    # generate Release.gpg
    rm -fr "${DISTS_ANY}/Release.gpg"
    gpg --default-key "${KEYNAME}" -abs -o "${DISTS_ANY}/Release.gpg" "${DISTS_ANY}/Release"
    
    # generate InRelease
    rm -fr "${DISTS_ANY}/InRelease"
    gpg --default-key "${KEYNAME}" --clearsign -o "${DISTS_ANY}/InRelease" "${DISTS_ANY}/Release"
}

#===================================================
# Function for RPM Repo
#===================================================

update_rpm_repo() {
    RPM_FILE="$1"
    RPM_REPO_DIR="$2"

    # query rpm version and package name
    RPM_FULLNAME=$(rpm -qp "${RPM_FILE}")

    echo "Copying ${RPM_FILE} to ${RPM_REPO_DIR}/${RPM_FULLNAME}.rpm" 
    cp "${RPM_FILE}" "${RPM_REPO_DIR}/${RPM_FULLNAME}.rpm"

    # remove and replace repodata
    createrepo_c --update ${RPM_REPO_DIR}

    rm -f "${RPM_REPO_DIR}/repodata/repomd.xml.asc"
    gpg --default-key "${KEYNAME}" -abs -o "${RPM_REPO_DIR}/repodata/repomd.xml.asc" "${RPM_REPO_DIR}/repodata/repomd.xml"
}
