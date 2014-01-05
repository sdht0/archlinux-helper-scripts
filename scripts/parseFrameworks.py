
import xml.etree.ElementTree as ElementTree
import os
tree = ElementTree.parse('/home/lfiles/dev/sources/kde5/kde_projects.xml')
root = tree.getroot()
itemlist = root.find('component').findall('module')
allitems=[]
for item in itemlist:
    name=item.attrib['identifier']
    data={"name":name}
    data['description']=item.find('description').text.strip()
    data['web']=item.find('web').text.strip()
    data['url']=item.find('repo').find('url').text.strip()
    allitems.append(data)

base='''
pkgname=kf5-[name]-git
_pkgname=[name]
pkgver=255
pkgrel=1
pkgdesc="[description]"
arch=('i686' 'x86_64')
url="[web]"
license=('LGPL')
depends=('qt5-base')
makedepends=('extra-cmake-modules-git' 'git')
conflicts=("kf5-${_pkgname}" "${_pkgname}-git" "${_pkgname}")
provides=("kf5-${_pkgname}" "${_pkgname}")
source=("[url]")
md5sums=('SKIP')

pkgver() {
  cd "${_pkgname}"
  echo $(git rev-list --count HEAD).$(git rev-parse --short HEAD)
}

prepare() {
  mkdir -p build
}

build() {
  cd build
  /opt/kf5/bin/cmake ../"${_pkgname}" \\
    -DCMAKE_INSTALL_PREFIX=/opt/kf5 \\
    -DCMAKE_BUILD_TYPE=DebugFull \\
    -DLIB_INSTALL_DIR=lib
  make
}

package() {
  cd build
  make DESTDIR="${pkgdir}" install
}
'''

basepath = "/home/lfiles/dev/archlinux-PKGBUILDs/kf5-frameworks"

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