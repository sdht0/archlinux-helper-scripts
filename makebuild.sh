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

# indicate 'usemakepkg' to build using makepkg, anything else uses ccm
usemakepkg="$3"

# used to indicate options
# On using makepkg, options to makepkg can be sent, eg "-si --needed --noconfirm"
# On using ccm, "noclean" can be indicated to not clean chroot before building the package
uoptions="$4"

BASEDIR=/run/media/sdh/sdh-hdd3/dev

printf "\n****************************Building $pkgname*****************************\n"
fd=$BASEDIR/archlinux-PKGBUILDs/${folder}$pkgname
cd  $fd || exit 2 && \
echo "Entering $(pwd)..." && \
if [[ "$usemakepkg" = "usemakepkg" ]];then
    makepkg --config=$BASEDIR/makepkg.conf $uoptions || exit 1
else
    if [ "$uoptions" = "noclean" ];then
        sudo ccm S || exit 1
    else
        sudo ccm s || exit 1
    fi
fi && \
source PKGBUILD && \
for i in ${pkgname[@]};do
    find $BASEDIR/archlinux-pkgfiles \( -name "$i*.tar.xz" -or -name "$i*.tar.gz" \) \
        -not \( -name "$i*-$pkgver-$pkgrel*.tar.xz" -or -name "$i*-$pkgver-$pkgrel*.tar.gz" \) -exec mv {} $BASEDIR/archlinux-logs/old-pkgfiles/ \;
done
echo