
import findDependencies
directdependencies=findDependencies.findDependencies()

import xml.etree.ElementTree as ElementTree
import os,sys

basepath = "/run/media/sdh/sdh-hdd3/dev/archlinux-logs/b"

tree = ElementTree.parse('/run/media/sdh/sdh-hdd3/sources/kde5/kde_projects.xml')
root = tree.getroot()
components = root.findall('component')
itemlist = []
for i in components:
    if i.attrib['identifier']=="kde":
        x = i.findall('module')
        for j in x:
            if j.attrib['identifier'] in ["workspace",'pim']:
                itemlist.extend(j.findall('project'))

allitems=[]
extradependencies={"kwin":"'libxcursor'",
                   "plasma-desktop":"'lomoco' 'libcanberra' 'libxkbfile'",
                   "kio-extras":"'openslp' 'samba' 'libssh' 'openexr' 'libkexiv2'"}
for item in itemlist:
    name=item.attrib['identifier']
    data={"name":name}
    data['description']=item.find('description').text.strip()
    data['web']=item.find('web').text.strip()
    data['url']="git://anongit.kde.org/%s" % name
    data['extra']=""
    data['depend']="'qt5-base'"
    if name in ['kio-extras']:
        data['depend']="'kde5-kf5umbrella-git'"
    if "kde5-%s-git" % name in directdependencies and len(directdependencies["kde5-%s-git" % name])!=0:
        data['depend']="'%s'" % ("' '".join(sorted(list(directdependencies["kde5-%s-git" % name]))))
    data['depend']+=" "+extradependencies[name] if name in extradependencies else ""
    data['depend']=data['depend'].replace("kde5-kdesupport/attica","kde5-attica").replace("kde5-kdesupport/phonon/phonon","kde5-phonon-qt5")
    if name in ['kdoctools']:
        data['extra']="\noptions=('staticlibs')"
    data['extraoptions']=""
    if name in ["solid"]:
        data['extraoptions']=" \\\n        -DHUPNP_ENABLED=FALSE"
    allitems.append(data)

base='''
pkgname=kde5-[name]-git
_pkgname=[name]
pkgver=1
pkgrel=1
pkgdesc="[description]"
arch=('i686' 'x86_64')
url="[web]"
license=('LGPL')
depends=([depend])
makedepends=('kde5-extra-cmake-modules-git' 'git')
group=("kde5")
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
    export PATH="/opt/kde5/bin:$PATH"
    export XDG_DATA_DIRS="/opt/kde5/share:$XDG_DATA_DIRS"

    cd build
    cmake ../"${_pkgname}" \\
        -DCMAKE_INSTALL_PREFIX=/opt/kde5 \\
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
    print(i['name'],end=' ')
    text = base
    for data in i:
        text = text.replace("[%s]" % data,i[data])
    path=basepath+"/kde5-%s-git" % i['name']
    if not os.path.exists(path):
        os.mkdir(path)
    f=open(path+"/PKGBUILD","w")
    f.write(text)
    f.close()
print()