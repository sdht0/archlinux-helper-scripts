#!/usr/bin/zsh

BASEDIR=/run/media/sdh/sdh-hdd3/dev
PKGBUILDSDIR=$BASEDIR/archlinux-PKGBUILDs

pkggroup="$1"

# indicate 'usemakepkg' to build using makepkg, anything else uses ccm
usemakepkg="$2"

# used to indicate options
# On using makepkg, options to makepkg can be sent, eg "-si --needed --noconfirm"
# On using ccm, following options can be indicated:
#   noclean       - the chroot is not cleaned before building any package.
#   initialclean  - the chroot is cleaned only before building first package.
#   continue      - the chroot is not cleaned only after building the first package. Used to continue a aborted build.
uoptions="$3"

# indicate 'nonewchroot' to not recreate the chroot before starting the build. This is only valid if ccm is used.
nonewchroot="$4"

case "$pkggroup" in
    kde5)
        folder="kde5"
        prepackages=('cmake' 'shared-mime-info' 'qt5-base' 'qt5-tools' 'git')
        packages=(
#             kde5-extra-cmake-modules-git kde5-attica-git kde5-kconfig-git kde5-ki18n-git kde5-kdbusaddons-git kde5-kwindowsystem-git kde5-kcoreaddons-git kde5-kcrash-git kde5-karchive-git kde5-kdoctools-git kde5-kservice-git kde5-kitemviews-git
            kde5-kauth-git kde5-kcodecs-git kde5-kguiaddons-git kde5-kwidgetsaddons-git kde5-kconfigwidgets-git kde5-kiconthemes-git kde5-kglobalaccel-git kde5-kcompletion-git kde5-sonnet-git kde5-ktextwidgets-git kde5-kxmlgui-git kde5-kcmutils-git kde5-solid-git kde5-kjobwidgets-git kde5-kbookmarks-git kde5-knotifications-git kde5-kwallet-git kde5-kio-git kde5-kdeclarative-git kde5-kactivities-git kde5-kunitconversion-git kde5-kinit-git kde5-kparts-git kde5-kplotting-git kde5-kdewebkit-git kde5-kdesignerplugin-git kde5-kdelibs4support-git kde5-kded-git kde5-kdnssd-git kde5-kemoticons-git kde5-kjs-git kde5-khtml-git kde5-kidletime-git kde5-kjsembed-git kde5-kitemmodels-git kde5-knewstuff-git kde5-knotifyconfig-git kde5-frameworkintegration-git kde5-kpty-git kde5-kdesu-git kde5-kross-git kde5-ktexteditor-git kde5-threadweaver-git kde5-kpackage-git kde5-plasma-framework-git kde5-kxmlrpcclient-git kde5-kimageformats-git kde5-kapidox-git kde5-krunner-git kde5-kmediaplayer-git kde5-networkmanager-qt-git kde5-ksshaskpass-git kde5-kde-gtk-config-git kde5-oxygen-fonts-git kde5-libmm-qt-git kde5-plasma-nm-git kde5-kdecoration-git kde5-kwayland-git kde5-libksysguard-git kde5-kwin-git kde5-kfilemetadata-git kde5-baloo-git kde5-milou-git kde5-khelpcenter-git kde5-kde-cli-tools-git kde5-kio-extras-git kde5-breeze-git kde5-libkscreen-git kde5-plasma-workspace-git kde5-kmenuedit-git kde5-systemsettings-git kde5-polkit-kde-agent-1-git kde5-kwrited-git kde5-kscreen-git kde5-khotkeys-git kde5-libbluedevil-git kde5-muon-git kde5-powerdevil-git kde5-kdeplasma-addons-git kde5-oxygen-git kde5-bluedevil-git kde5-user-manager-git kde5-kinfocenter-git kde5-ksysguard-git kde5-plasma-desktop-git kde5-sddm-kcm-git kde5-kcontacts-git kde5-kcalcore-git kde5-syndication-git kde5-kblog-git kde5-kpimtextedit-git kde5-kidentitymanagement-git kde5-kcalutils-git kde5-kholidays-git kde5-kmime-git kde5-kimap-git kde5-kldap-git kde5-kmbox-git kde5-kontactinterface-git kde5-ktnef-git kde5-gpgmepp-git kde5-kmailtransport-git kde5-kalarmcal-git kde5-akonadi-calendar-git
        )
        ;;
    ktp)
        folder="telepathy-kde"
        prepackages=('kdebase-runtime' 'cmake' 'git' 'automoc4' 'kdepimlibs')
        packages=(
                'libkpeople-git' 'telepathy-logger-qt-git'
                'telepathy-kde-common-internals-git' 'telepathy-kde-contact-list-git' 'telepathy-kde-filetransfer-handler-git'
                'telepathy-kde-send-file-git' 'telepathy-kde-integration-module-git' 'telepathy-kde-auth-handler-git' 'telepathy-kde-text-ui-git'
                'telepathy-kde-approver-git' 'telepathy-kde-accounts-kcm-git' 'telepathy-kde-desktop-applets-git' 'telepathy-kde-contact-runner-git'
                'telepathy-kde-git-meta')
        ;;
    kte)
        folder="kte-collaborative"
        packages=('libqinfinity-git' 'kte-collaborative-git')
        ;;
    active)
        folder="telepathy-kde-active"
        packages=('kde-plasma-mobile-git' 'plasmate-git')
        ;;
    rest)
        folder="-"
        packages=('clean-chroot-manager-git' 'cower' 'google-talkplugin' 'guayadeque-svn')
        ;;
    *)  printf "kde5\nkte\ntelepathy\nactive\nrest\n";
        exit 1
        ;;
esac

if [[ "$usemakepkg" = "usemakepkg" ]];then
    echo -n "Cleaning build dir..." && \
    sudo rm -rf $BASEDIR/build/* && \
    find $PKGBUILDSDIR -name '*.xz' -exec rm -rf {} \; && \
    echo "done"
else
    if [[ "$nonewchroot" != "nonewchroot" ]];then
        printf "Are you sure you want to nuke chroot? [y|N]: "
        read inp && [[ "$inp" = "y" ]] && { sudo ccm n && sudo ccm c }
    fi
    echo "Updating and preinstalling packages..." && \
    sudo arch-nspawn $BASEDIR/archlinux-chroot/root pacman -Syu --needed --noconfirm $prepackages[@]
fi

opt="" && [[ "$uoptions" = "continue" ]] && opt="noclean"
for ((i=1;i<=${#packages[@]};i++));do
    if [[ "$usemakepkg" = "usemakepkg" ]];then
        /usr/bin/bash $BASEDIR/makebuild.sh ${packages[$i]} $folder usemakepkg $uoptions || exit 1
    else
        [[ "$uoptions" = "noclean" ]] && opt="noclean"
        /usr/bin/bash $BASEDIR/makebuild.sh ${packages[$i]} $folder useccm "$opt"  || exit 1
        [[ "$uoptions" = "initialclean" ]] && opt="noclean"
        [[ "$uoptions" = "continue" ]] && opt=""
    fi
done

printf "\nCleaning pkg files..." && \
find $PKGBUILDSDIR -name '*.xz' -exec rm -rf {} \; && \
echo "done"
