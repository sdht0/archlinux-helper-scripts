
import findDependencies
directdependencies=findDependencies.findDependencies()

import xml.etree.ElementTree as ElementTree
import os,sys

basepath = "/home/lfiles/dev/archlinux-logs/a"

tree = ElementTree.parse('/home/lfiles/kde5/sources/kde_projects.xml')
root = tree.getroot()
components = root.findall('component')
for i in components:
    if i.attrib['identifier']=="frameworks":
        itemlist = i.findall('module')

allitems=[]
extradependencies={"kapidox":"'python2'",
                    "kauth":"'kde5-polkit-qt5-git'",
                    "kdewebkit":"'qt5-webkit'",
                    "kde4support":"'qt5-tools'",
                    "kdnssd-framework":"'avahi'",
                    "kdoctools":"'docbook-xsl'",
                    "kfileaudiopreview":"'kde5-phonon-qt5-git'",
                    "khtml":"'kde5-phonon-qt5-git' 'giflib'",
                    "kiconthemes":"'qt5-svg'",
                    "kidletime":"'libxss'",
                    "kimageformats":"'jasper' 'openexr'",
                    "kio":"'krb5' 'qt5-script'",
                    "kjobwidgets":"'qt5-x11extras'",
                    "kjsembed":"'qt5-svg' 'qt5-tools'",
                    "knotifications":"'kde5-libdbusmenu-qt5-bzr' 'kde5-phonon-qt5-git'",
                    "kpty":"'libutempter'",
                    "kwallet":"'gpgme'",
                    "kross":"'qt5-tools'",
                    "kwindowsystem":"'libxfixes'",
                    "solid":"'media-player-info' 'upower' 'udisks2'",
                    "sonnet":"'enchant'",
                    "knotifyconfig":"'kde5-phonon-qt5-git'"}
for item in itemlist:
    name=item.attrib['identifier']
    data={"name":name}
    data['description']=item.find('description').text.strip()
    data['web']=item.find('web').text.strip()
    data['url']=item.find('repo').find('url').text.strip()
    data['extra']=""
    data['depend']="'qt5-base'"
    if name in ["kglobalaccel", "kidletime" ,"kwindowsystem"]:
        data['depend']="'qt5-x11extras'"
    elif name in ["solid"]:
        data['depend']="'qt5-declarative'"
    elif name in ["ki18n"]:
        data['depend']="'qt5-script'"
    if "kf5-%s-git" % name in directdependencies:
        data['depend']="'%s'" % ("' '".join(sorted(list(directdependencies["kf5-%s-git" % name]))))
    data['depend']+=" "+extradependencies[name] if name in extradependencies else ""
    if name in ['kdoctools']:
        data['extra']="\noptions=('staticlibs')"
    data['extraoptions']=""
    if name in ["solid"]:
        data['extraoptions']=" \\\n        -DHUPNP_ENABLED=FALSE"
    allitems.append(data)

base='''
pkgname=kf5-[name]-git
_pkgname=[name]
pkgver=1
pkgrel=1
pkgdesc="[description]"
arch=('i686' 'x86_64')
url="[web]"
license=('LGPL')
depends=([depend])
makedepends=('extra-cmake-modules-git' 'git')
group=("kf5")
conflicts=("${_pkgname}-git")
provides=("${_pkgname}-git")
source=("[url]")
md5sums=('SKIP')[extra]

pkgver() {
    cd "${_pkgname}"
    echo $(git rev-list --count HEAD).$(git rev-parse --short HEAD)
}

prepare() {
    mkdir -p build
}

build() {
    export PATH="/opt/kf5/bin:$PATH"
    export XDG_DATA_DIRS="/opt/kf5/share:$XDG_DATA_DIRS"
    export LD_LIBRARY_PATH="/opt/kf5/lib:$LD_LIBRARY_PATH"
    export PKG_CONFIG_PATH="/opt/kf5/lib/pkgconfig:$PKG_CONFIG_PATH"
    export KDEDIRS="/opt/kf5"

    cd build
    cmake ../"${_pkgname}" \\
        -DCMAKE_INSTALL_PREFIX=/opt/kf5 \\
        -DCMAKE_BUILD_TYPE=Debug \\
        -DLIB_INSTALL_DIR=lib[extraoptions]
    make
}

package() {
    cd build
    make DESTDIR="${pkgdir}" install
}
'''

for i in allitems:
    print("'kf5-%s-git'"%i['name'],end=' ')
    text = base
    for data in i:
        text = text.replace("[%s]" % data,i[data])
    path=basepath+"/kf5-%s-git" % i['name']
    if not os.path.exists(path):
        os.mkdir(path)
    f=open(path+"/PKGBUILD","w")
    f.write(text)
    f.close()