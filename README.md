Archlinux Helper Scripts
========================

This is a collection of Bash helper scripts to:

* install Arch Linux on _my_ system.
* submit packages to AUR.
* build multiple PKGBUILDs at once, especially a group of packages of same application.

Install scripts
---------------
Scripts for my particular installation and configuration of Arch Linux.

AUR Uploader
------------
Bash script to upload a package file to AUR.

Build scripts
-------------
### > makebuild.sh
This is used to build a single package using either makepkg or in a chroot using [clean chroot manager](https://github.com/graysky2/clean-chroot-manager).

Example usage:

* `./makebuild.sh cower -` : Builds using ccm
* `./makebuild.sh clean-chroot-manager-git - "-si --needed --noconfirm" usemakepkg` : Builds using makepkg using given arguments
* `./makebuild.sh kde-workspace-git kf5 "noclean" useccm` : Builds using ccm without cleaning the chroot first

### > custombuild.sh
This is used to build a group of related packages using `makebuild.sh`.

Folder structure:

$BASEDIR  
|-- archlinux-PKGBUILDs  
|-- archlinux-pkgfiles  
|-- archlinux-sources  
|-- build  
|-- archlinux-extra
    |-- archlinux-logs

* I have all my PKGBUILDs in the `$BASEDIR/archlinux-PKGBUILDs` folder, with sub-folders used for packages of same group.
* The folder names are the same as the name of the package.
* I further separate the various outputs of the build as shown above by using `makepkg.conf` and `clean-chroot-manager.conf`.

Variables:

* `packages`: The order in which packages are to be built
* `prepackages`: A set of common dependencies which are installed in the base chroot to prevent installing them repeatedly for each package

Example usage:

* `./custombuild.sh telepathy` : Builds using ccm after creating a new chroot
* `./custombuild.sh kf5 usemakepkg "-sif --noconfirm"` : Builds using makepkg using given arguments
* `./custombuild.sh telepathy useccm "continue" nonewchroot` : Builds using ccm without creating a new chroot first, and also retain previous chroot state for the first package

Requirements
------------
* makepkg requires installation of base-devel group
* ccm can be installed from the [AUR](https://aur.archlinux.org/packages/clean-chroot-manager).

Note: The `noclean` option of ccm is a customization I made myself. It is not yet [merged](https://github.com/graysky2/clean-chroot-manager/pull/9) to the main repo. Until then, you can get that feature using a [patch](https://github.com/siddharthasahu/archlinux-build-helper/tree/master/archlinux-PKGBUILDs/clean-chroot-manager-git).

License
-------
GNU GPLv3