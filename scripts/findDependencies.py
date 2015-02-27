import subprocess
import copy

def findDependencies():
    data=open("/run/media/sdh/sdh-hdd3/sources/kde5/kde-build-metadata/dependency-data-kf5-qt5","r").readlines()
    directdependencies={}
    reversedependencies={}
    extra=set()
    for line in data:
        line=line.strip(" \n").replace(" ","")
        if line.find("frameworks/")==0 or line.find("kde/workspace/")==0:
            line=line.replace("#KDecorations","").replace("#testdependency","")
            parts=line.split(":")
            if parts[1][0]=="-":
                continue
            for i in range(2):
                    parts[i]="kde5-%s-git" % parts[i].split('/')[-1]
            if parts[0] not in directdependencies:
                directdependencies[parts[0]]=set()
            directdependencies[parts[0]].add(parts[1])
            if parts[1] not in reversedependencies:
                reversedependencies[parts[1]]=set()
            reversedependencies[parts[1]].add(parts[0])

    text="digraph A {"
    for d in directdependencies:
        for dn in directdependencies[d]:
            text+='"%s"->"%s";\n' % (dn,d)
    text+="}"
    f = open("alldependencies.dot","w")
    f.write(text)
    f.close()

    bk=copy.deepcopy(directdependencies)

    def removeDependencyFrom(fname, name):
        if name in directdependencies[fname]:
            directdependencies[fname].remove(name)

    visited=set()
    def searchDependencies(framework, f):
        if framework in visited or framework not in bk:
            return
        visited.add(framework)
        for name in bk[framework]:
            for fname in reversedependencies[f]:
                removeDependencyFrom(fname, name)
            searchDependencies(name,f)

    for framework in bk:
        if framework in reversedependencies:
            visited=set()
            searchDependencies(framework, framework)

    fl=open("dependencies.txt","w")
    text="digraph A {"
    for d in directdependencies:
        fl.write(d+"\n")
        fl.write(",".join(sorted(list(bk[d])))+"\n")
        fl.write(",".join(sorted(list(directdependencies[d])))+"\n\n")
        for dn in directdependencies[d]:
            text+='"%s"->"%s";\n' % (dn,d)
    text+="}"
    f = open("minimiseddependencies.dot","w")
    f.write(text)
    f.close()
    fl.close()
    return directdependencies

if __name__ == '__main__':
    x=findDependencies()
    for i in x:
        print(i,sorted(list(x[i])))