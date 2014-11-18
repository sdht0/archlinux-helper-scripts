#!/usr/bin/zsh

BASEDIR=/home/sdh/dev
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
    kf5)
        folder="kf5"
        prepackages=('shared-mime-info' 'qt5-base' 'git')
        packages=(
                # buid system
                'cmake-git'
                'extra-cmake-modules-git'

                # dependencies
                'kde5-libdbusmenu-qt5-bzr' 'kde5-phonon-qt5-git' 'kde5-akonadi-git' 'kde5-phonon-gstreamer-git' 'kde5-polkit-qt5-git'

                # tier 1
                'kf5-attica-git' 'kf5-karchive-git' 'kf5-kcodecs-git' 'kf5-kconfig-git' 'kf5-kcoreaddons-git' 'kf5-kdbusaddons-git'
                'kf5-kglobalaccel-git' 'kf5-kguiaddons-git'  'kf5-ki18n-git' 'kf5-kidletime-git' 'kf5-kimageformats-git'
                'kf5-kitemmodels-git' 'kf5-kitemviews-git' 'kf5-kjs-git' 'kf5-kplotting-git' 'kf5-kwidgetsaddons-git'
                'kf5-kwindowsystem-git' 'kf5-solid-git' 'kf5-sonnet-git' 'kf5-threadweaver-git'

                # tier 2
                'kf5-kauth-git' 'kf5-kcompletion-git' 'kf5-kcrash-git' 'kf5-kdnssd-git' 'kf5-kdoctools-git'
                'kf5-kjobwidgets-git' 'kf5-kpty-git' 'kf5-kunitconversion-git'

                # tier 3
                'kf5-kjsembed-git' 'kf5-kconfigwidgets-git' 'kf5-kiconthemes-git' 'kf5-kservice-git' 'kf5-knotifications-git'
                'kf5-ktextwidgets-git' 'kf5-kxmlgui-git' 'kf5-kbookmarks-git' 'kf5-kcmutils-git' 'kf5-kwallet-git' 'kf5-kio-git'
                'kf5-kdeclarative-git' 'kf5-kinit-git' 'kf5-kded-git' 'kf5-kdesu-git' 'kf5-kparts-git' 'kf5-kdewebkit-git'
                'kf5-kdesignerplugin-git' 'kf5-kemoticons-git' 'kf5-kmediaplayer-git' 'kf5-kross-git' 'kf5-knewstuff-git'
                'kf5-knotifyconfig-git' 'kf5-ktexteditor-git' 'kf5-kactivities-git' 'kf5-plasma-framework-git'

#                 tier 4
                'kf5-frameworkintegration-git' 'kf5-krunner-git' 'kf5-kapidox-git' 'kf5-kfileaudiopreview-git' 'kf5-khtml-git'
                'kf5-kdelibs4support-git'

                # all
                'kf5-kf5umbrella-git'

#                 KDE 5
                'kde5-systemsettings-git' 'kde5-libksysguard-git' 'kde5-kwin-git' 'kde5-khelpcenter-git' 'kde5-kde-cli-tools-git'
                'kde5-kio-extras-git' 'kde5-plasma-workspace-git' 'kde5-ksysguard-git' 'kde5-oxygen-git'
                'kde5-plasma-desktop-git'
                'kde5-kmenuedit-git' 'kde5-khotkeys-git' 'kde5-kinfocenter-git' 'kde5-kwrited-git'

                #'kde5-kfilemetadata-git' 'kde5-baloo-git' 'kde5-milou-git'
                )
        packages_new=(
            libdbusmenu-qt extra-cmake-modules attica kconfig ki18n kdbusaddons kwindowsystem kcoreaddons kcrash karchive kdoctools
            kservice kitemviews kauth kcodecs kguiaddons kwidgetsaddons kconfigwidgets kiconthemes kglobalaccel kcompletion sonnet
            ktextwidgets kxmlgui kcmutils solid kjobwidgets kbookmarks phonon knotifications kwallet kio kdeclarative kactivities kunitconversion
            kinit kparts kplotting kdewebkit kdesignerplugin kdelibs4support kded kdnssd kemoticons kjs khtml kidletime kjsembed kitemmodels
            knewstuff knotifyconfig frameworkintegration kpty kdesu kross ktexteditor threadweaver plasma-framework kdesrc-build
            phonon-vlc phonon-gstreamer akonadi kapidox krunner kmediaplayer kimageformats libksysguard kwayland kwin kfilemetadata baloo
            khelpcenter kde-cli-tools kio-extras breeze libkscreen plasma-workspace khotkeys powerdevil kwrited oxygen-fonts kde-gtk-config
            kmenuedit systemsettings kinfocenter ksysguard oxygen plasma-desktop libmm-qt libnm-qt plasma-nm kdeplasma-addons milou muon
            libkomparediff2 kdevplatform plasmate libbluedevil bluedevil kwalletmanager baloo-widgets kscreen konsole kate kde-baseapps gwenview
            okular ksnapshot okteta kdevelop libksane skanlite yakuake ktp-common-internals ktp-desktop-applets konversation kmix prison
            kdepimlibs libkgapi grantlee kdepim kdepim-runtime
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
    plasma-nm)
        folder="plasma-nm"
        packages=('libnm-qt' 'kdeplasma-applets-plasma-nm-git')
        ;;
    android)
        folder="-"
        packages=('android-sdk' 'android-sdk-platform-tools' 'android-sdk-build-tools')
        ;;
    rest)
        folder="-"
        packages=('clean-chroot-manager-git' 'cower' 'google-talkplugin' 'guayadeque-svn')
        ;;
    *)  printf "kf5\nkte\ntelepathy\nactive\nrest\n";
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
