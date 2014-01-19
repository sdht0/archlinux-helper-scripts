#!/usr/bin/zsh

BASEDIR=/home/lfiles/dev
PKGBUILDSDIR=$BASEDIR/archlinux-PKGBUILDs

pkggroup="$1"

# used to indicate options
# On using makepkg, options to makepkg can be sent, eg "-si --needed --noconfirm"
# On using ccm, following options can be indicated:
#   noclean       - the chroot is not cleaned before building any package.
#   initialclean  - the chroot is cleaned only before building first package.
#   continue      - the chroot is not cleaned only after building the first package. Used to continue a aborted build.
uoptions="$2"

# indicate 'usemakepkg' to build using makepkg, anything else uses ccm
usemakepkg="$3"

# indicate 'nonewchroot' to not recreate the chroot before starting the build. This is only valid if ccm is used.
nonewchroot="$4"

case "$pkggroup" in
    kf5)
        folder="kf5"
        prepackages=("shared-mime-info" "qt5-base" "git")
        packages=(
                # buid system
#                 'cmake-git'
#                 'extra-cmake-modules-git'

                # dependencies
#                 'kde5-libdbusmenu-qt5-bzr' 'kde5-attica-git' 'kde5-akonadi-git' 'kde5-polkit-qt-git' 'kde5-strigi-git' 'kde5-phonon-qt5-git'

                # tier 1
                'kf5-1-kitemmodels-git' 'kf5-1-kitemviews-git' 'kf5-1-karchive-git' 'kf5-1-kcodecs-git'  'kf5-1-kconfig-git'
                'kf5-1-kcoreaddons-git' 'kf5-1-kdbusaddons-git' 'kf5-1-kglobalaccel-git' 'kf5-1-kguiaddons-git' 'kf5-1-kidletime-git'
                'kf5-1-kimageformats-git' 'kf5-1-kjs-git' 'kf5-1-kplotting-git' 'kf5-1-kwidgetsaddons-git' 'kf5-1-kwindowsystem-git'
                'kf5-1-solid-git' 'kf5-1-sonnet-git' 'kf5-1-threadweaver-git'

                # tier 2
                'kf5-2-kauth-git' 'kf5-2-kcompletion-git' 'kf5-2-kcrash-git' 'kf5-2-kdoctools-git' 'kf5-2-kdnssd-framework-git'
                'kf5-2-ki18n-git' 'kf5-2-kjobwidgets-git' 'kf5-2-knotifications-git' 'kf5-2-kwallet-framework-git'

                # tier 3
                'kf5-3-kconfigwidgets-git' 'kf5-3-kiconthemes-git' 'kf5-3-kservice-git' 'kf5-3-ktextwidgets-git' 'kf5-3-kxmlgui-git'
                'kf5-3-kbookmarks-git' 'kf5-3-kcmutils-git' 'kf5-3-kio-git' 'kf5-3-kdeclarative-git' 'kf5-3-kinit-git' 'kf5-3-kded-git'
                'kf5-3-kpty-git' 'kf5-3-kdesu-git' 'kf5-3-kparts-git' 'kf5-3-kdewebkit-git' 'kf5-3-kdesignerplugin-git'
                'kf5-3-kemoticons-git' 'kf5-3-kjsembed-git' 'kf5-3-kmediaplayer-git' 'kf5-3-kprintutils-git' 'kf5-3-kross-git'
                'kf5-3-kunitconversion-git' 'kf5-3-knewstuff-git' 'kf5-3-knotifyconfig-git'

                # tier 4
                'kf5-4-kapidox-git' 'kf5-4-frameworkintegration-git' 'kf5-4-kde4support-git' 'kf5-4-kfileaudiopreview-git' 'kf5-4-khtml-git'

                # all tiers
                'kf5-kf5umbrella-git'

                # KDE 5
                'kde5-kactivities-frameworks-git' 'kde5-plasma-framework-git' 'kde5-workspace-git' 'kde5-runtime-git'
                )
        ;;
    telepathy)
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
        packages=('libqinfinity-git'
                'kte-collaborative-git')
        ;;
    active)
        folder="telepathy-kde-active"
        packages=('kde-plasma-mobile-git'
                'plasmate-git')
        ;;
    rest)
        folder="-"
        packages=('cower'
                'google-talkplugin'
                'eiskaltdcpp-qt')
        cd $PKGBUILDSDIR
        for ((i=1;i<=${#packages[@]};i++));do
            cower -df ${packages[$i]}
        done
        packages=($packages[@] 'guayadeque-svn')
        ;;
    *)  printf "kf5\nkte\ntelepathy\nactive\nrest\n";
        exit 1
        ;;
esac

if [[ "$usemakepkg" != "usemakepkg" ]];then
    if [[ "$nonewchroot" != "nonewchroot" ]];then
        printf "Are you sure you want to nuke chroot? [Y|n]: "
        read inp && [[ "$inp" = "n" ]] && exit 1
        sudo ccm n && sudo ccm c
    fi
    echo "Updating and preinstalling packages..." && \
    sudo arch-nspawn $BASEDIR/archlinux-chroot/root pacman -Syu --needed --noconfirm $prepackages[@]
else
    echo -n "Cleaning build dir..." && \
    rm -rf $BASEDIR/build/makepkg/* && \
    find $PKGBUILDSDIR -name '*.xz' -exec rm -rf {} \; && \
    echo "done"
fi

opt="" && [[ "$uoptions" = "continue" ]] && opt="noclean"
for ((i=1;i<=${#packages[@]};i++));do
    if [[ "$usemakepkg" = "usemakepkg" ]];then
        /usr/bin/bash $BASEDIR/makebuild.sh ${packages[$i]} $folder $uoptions usemakepkg || exit 1
    else
        [[ "$uoptions" = "noclean" ]] && opt="noclean"
        /usr/bin/bash $BASEDIR/makebuild.sh ${packages[$i]} $folder "$opt"  || exit 1
        [[ "$uoptions" = "initialclean" ]] && opt="noclean"
        [[ "$uoptions" = "continue" ]] && opt=""
    fi
done

printf "\nCleaning pkg files..." && \
find $PKGBUILDSDIR -name '*.xz' -exec rm -rf {} \; && \
echo "done"
