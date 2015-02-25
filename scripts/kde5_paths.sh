#!/bin/sh

export KF5=/opt/kde5
export QTDIR=/usr/lib/qt

export PATH=$KF5/bin:$QTDIR/bin:$PATH

export QT_PLUGIN_PATH=$KF5/lib/plugins:$QTDIR/plugins:$QT_PLUGIN_PATH
export QML2_IMPORT_PATH=$KF5/lib/qml:$QTDIR/qml
export QML_IMPORT_PATH=$QML2_IMPORT_PATH

export KDE_SESSION_VERSION=5
export KDE_FULL_SESSION=true

export XDG_DATA_DIRS=$KF5/share:$XDG_DATA_DIRS:/usr/share
export XDG_CONFIG_DIRS=$KF5/etc/xdg:$XDG_CONFIG_DIRS:/etc/xdg

export XDG_DATA_HOME=/home/sdh/.kde5/local
export XDG_CONFIG_HOME=/home/sdh/.kde5/config
export XDG_CACHE_HOME=/home/sdh/.kde5/cache

