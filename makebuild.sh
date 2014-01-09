#!/usr/bin/bash
# Used to build a single package using either makepkg or ccm

if [ -z "$1" ];then
    echo "Package name required!"
    exit 1
fi
pkgname="$1"
if [ -z "$2" ];then
    echo "No 2nd input!"
    exit 1
fi
if [ "$2" != "-" -a "$2" != "" ];then
    folder="$2/"
fi

# used to indicate options
# On using makepkg, options to makepkg can be sent, eg "-si --needed --noconfirm"
# On using ccm, "noclean" can be indicated to not clean chroot before building the package
uoptions="$3"

# indicate 'usemakepkg' to build using makepkg, anything else uses ccm
usemakepkg="$4"

BASEDIR=/home/lfiles/dev

printf "\n****************************Building $pkgname*****************************\n"
fd=$BASEDIR/archlinux-PKGBUILDs/${folder}$pkgname
cd  $fd || exit 2 && \
echo "Entering $(pwd)..." && \
if [[ "$usemakepkg" = "usemakepkg" ]];then
    makepkg --config=$BASEDIR/makepkg.conf $uoptions || exit 1
else
    sudo ccm s $uoptions || exit 1
fi && \
. PKGBUILD && \
find $BASEDIR/archlinux-pkgfiles \( -name "$pkgname*.tar.xz" -or -name "$pkgname*.tar.gz" \) \
		-not \( -name "$pkgname-$pkgver-$pkgrel*.tar.xz" -or -name "$pkgname-$pkgver-$pkgrel*.tar.gz" \) -exec rm -rf {} \;
echo