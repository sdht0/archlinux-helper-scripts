import os,glob,re

data={}
fl=open("/home/lfiles/dev/d","r")
for l in fl.readlines():
    x=l.split(":")
    data[x[0].strip()]=x[1].strip(" \n").split()
visited={}
text="digraph A {"
for d in data.keys():
    dt=[]
    visited[d]=-1
    for x in data[d]:
        if x in data:
            text+='"%s"->"%s";' % (x,d)
            dt.append(x)
    data[d]=dt
    print(d+": ",data[d])
text+="}"
order=[]
od=[]
def walk(d):
    if visited[d]==0:
        raise Exception("Not DAG")
    visited[d]=0
    for x in data[d]:
        if visited[x]==-1:
            walk(x)
    visited[d]=1
    order.append(d)
    od.append(d.strip("").strip("-"))

for d in data:
    if visited[d]==-1:
        walk(d)
print(order)
print(od)
from os import popen
#print(text)
f = popen(r"dot -Tpng -o h.png", 'w')
f.write(text)
f.close()