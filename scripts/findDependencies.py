import subprocess
data=open("dependency-data-kf5-qt5","r").readlines()
directdependencies={}
reversedependencies={}
for line in data:
    line=line.strip(" \n").replace(" ","")
    if line.find("frameworks/")==0:
        parts=line.split(":")
        if parts[0] not in directdependencies:
            directdependencies[parts[0]]=set()
        directdependencies[parts[0]].add(parts[1])
        if parts[1] not in reversedependencies:
            reversedependencies[parts[1]]=set()
        reversedependencies[parts[1]].add(parts[0])

fl=open("fdata1","w")
text="digraph A {"
for d in directdependencies:
    fl.write(d+"\n")
    fl.write(",".join(list(directdependencies[d]))+"\n\n")
    for dn in directdependencies[d]:
        text+='"%s"->"%s";\n' % (dn.split("/")[1],d.split("/")[1])
text+="}"
f = open("h1.txt","w")
f.write(text)
f.close()
fl.close()

import copy
bk=copy.deepcopy(directdependencies)

for framework in directdependencies:
    if framework in reversedependencies:
        for name in directdependencies[framework]:
            for fname in reversedependencies[framework]:
                if name in directdependencies[fname]:
                    directdependencies[fname].remove(name)

fl=open("fdata2","w")
text="digraph A {"
for d in directdependencies:
    fl.write(d+"\n")
    fl.write(",".join(list(bk[d]))+"\n")
    fl.write(",".join(list(directdependencies[d]))+"\n\n")
    for dn in directdependencies[d]:
        text+='"%s"->"%s";\n' % (dn.split("/")[1],d.split("/")[1])
text+="}"
f = open("h2.txt","w")
f.write(text)
f.close()
fl.close()