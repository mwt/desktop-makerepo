#===================================================
# Function for DEB Repo
#===================================================

update_deb_repo() {
    cd "$STAGING_DIR"
    DEB_FILE="$1"

    PKG_VERSION=$(dpkg -f $DEB_FILE Version)
    PKG_NAME=$(dpkg -f $DEB_FILE Package)
    echo "Copying $DEB_FILE to $DEB_REPO_DIR/pool/${PKG_NAME:0:1}/$PKG_NAME/${PKG_NAME}_${PKG_VERSION}_amd64.deb" 
    mkdir -p "$DEB_REPO_DIR/pool/${PKG_NAME:0:1}/$PKG_NAME/"
    cp $DEB_FILE "$DEB_REPO_DIR/pool/${PKG_NAME:0:1}/$PKG_NAME/${PKG_NAME}_${PKG_VERSION}_amd64.deb"
    
    #===================================================
    # MAKE REPO
    #===================================================
    
    cd $DEB_REPO_DIR
    # Make package file for all packages
    apt-ftparchive --arch amd64 packages ./pool/ | tee ./dists/any/main/binary-amd64/Packages | gzip > ./dists/any/main/binary-amd64/Packages.gz
    # Make Release file for all
    apt-ftparchive --arch amd64 release -c "$SCRIPT_DIR/apt-ftparchive.conf" ./dists/any/ > ./dists/any/Release
    
    cd ./dists/any/
    # generate Release.gpg
    rm -fr Release.gpg; gpg --default-key ${KEYNAME} -abs -o Release.gpg Release
    
    # generate InRelease
    rm -fr InRelease; gpg --default-key ${KEYNAME} --clearsign -o InRelease Release
}

#===================================================
# Function for RPM Repo
#===================================================

update_rpm_repo() {
    cd "$STAGING_DIR"
    RPM_FILE="$1"

    ls "$RPM_FILE"
}