
export KF5=/home/lfiles/kde5/kdesrc/install
export KDEDIR=$KF5
export QTDIR=/usr/lib/qt

export PATH=$KF5/bin:$QTDIR/bin:$PATH

export QT_PLUGIN_PATH=$KF5/lib/plugins:$QTDIR/plugins:$QT_PLUGIN_PATH
export QML2_IMPORT_PATH=$KF5/lib/qml:$QTDIR/qml
export QML_IMPORT_PATH=$QML2_IMPORT_PATH

export KDE_SESSION_VERSION=5

export KDE_FULL_SESSION=true

export XDG_DATA_DIRS=$KF5/share:$XDG_DATA_DIRS:/usr/share
export XDG_CONFIG_DIRS=$KF5/etc/xdg:$XDG_CONFIG_DIRS:/etc/xdg

export XDG_DATA_HOME=/home/lfiles/kde5/kdesrc/.kde5/local
export XDG_CONFIG_HOME=/home/lfiles/kde5/kdesrc/.kde5/config
export XDG_CACHE_HOME=/home/lfiles/kde5/kdesrc/.kde5/cache

export KDEHOME=/home/lfiles/kde5/kdesrc/.kde5/local
export KDETMP=/home/lfiles/kde5/kdesrc/tmp
export KDEVARTMP=/home/lfiles/kde5/kdesrc/vartmp

export MANPATH=$KF5/share/man/:$MANPATH

## We need this for Mono/GAC libraries at runtime, so that apps dont crash
# export MONO_GAC_PREFIX=$KF5

## make the debug output prettier
export KDE_COLOR_DEBUG=1
export QTEST_COLORED=1

## Required for non standard installation path of cursors
# export XCURSOR_PATH=$KF5/share/icons
# export XCURSOR_THEME=Oxygen_White
