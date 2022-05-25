# Generate repo for Rclone

This repository contains scripts that generate APT and YUM repositories for Rclone. It is designed to be run at regular intervals using a cron job. However, it can also be run via [webhook](https://github.com/adnanh/webhook) when new packages are released. The repository consists of three main scripts. 

1. The first setup script, [`initial-setup/1-install-packages.sh`](./initial-setup/1-install-packages.sh), installs the required packages. It requires sudo access and should be run only once.
2. The second setup script, [`initial-setup/2-enviroment.zsh`](./initial-setup/2-enviroment.zsh), sets up the directory structure and dynamic configuration files. It can be run by an unprivileged user. It should be run directly only once.
3. The main script, [`build.zsh`](./build.zsh), generates the APT repo in `dist/deb` using [reprepro](https://salsa.debian.org/brlink/reprepro) and generates the YUM repo in `dist/rpm` using [createrepo-c](https://rpm-software-management.github.io/createrepo_c/). It should be rerun regularly to add updated packages to the repository.

Because the first script installs packages with APT, it only works on Debian and its derivatives. I have tested it on Debian and Ubuntu.
 
Running those three scripts should get you a working installation. The two setup scripts, [`initial-setup/1-install-packages.sh`](./initial-setup/1-install-packages.sh) and [`initial-setup/2-enviroment.zsh`](./initial-setup/2-enviroment.zsh) are split apart for two reasons. The first is that the installation script requires superuser access. So, it is reasonable to have the two scripts run by different users. The second is that the environment script has to be run anytime that the user cleans the repository (eg. using `git clean -dfx`). The [`clean.zsh`](./clean.zsh) script automates this process.


## Usage

There is a [minimal example using this with GitHub actions here](https://github.com/mwt/rclone-makerepo-example/blob/main/.github/workflows/test.yml). This example can be easily extended to any Debian based CI. First, you must install or generate a GPG key. Then you need to download and extract the latest release. After this, you can run the following inside the folder:

```sh
./initial-setup/1-install-packages.sh
./initial-setup/2-enviroment.zsh "$GPG_FINGERPRINT"
```

This installs all the dependencies and sets up the directory structure. After this, you an build the repositories:

```sh
./build.zsh
```


## Using for Other Projects

To make this work for other projects, you need to edit [`reprepro/conf/distributions`](./reprepro/conf/distributions) as well as the `REPO_LATEST_API` variable in [`build.zsh`](./build.zsh). The `SignWith` GPG key defined in the reprepro distributions file is also used to sign the YUM repository. 


## Dependencies

This script is written in [zsh](https://zsh.org/), a popular alternative to bash. This script directly runs the following commands.

**Basic dependencies:**
 - [sed](https://www.gnu.org/software/sed/) is used to read the GPG key id from a configuration file.
 - [GPG](https://gnupg.org/) is used to sign the repos.
 - [Wget](https://www.gnu.org/software/wget/) downloads json and packages.
 - [jq](https://stedolan.github.io/jq/) is used to process json files.

**APT repos:**
 - A [fork of reprepro](https://github.com/ionos-cloud/reprepro/) makes the APT repo. The fork supports multiple versions of the same package in a repo.

**YUM repos:**
 - [RPM](https://rpm.org/) is used to get the version info and architecture of RPM packages for renaming.
 - [createrepo-c](https://rpm-software-management.github.io/createrepo_c/) is used to make repo metadata for the YUM repo.
