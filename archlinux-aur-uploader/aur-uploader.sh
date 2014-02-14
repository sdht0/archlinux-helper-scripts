#!/bin/env bash

if [[ -z "$1" ]];then
    echo "Usage:"
    echo "aur-uploader filename.src.tar.gz [categoryname]"
    echo "aur-uploader updatecategories"
    echo "aur-uploader printcategories"
    echo "aur-uploader getcategoryid category"
    exit 1
fi

workdir=/tmp/aur
pushd `dirname $0` > /dev/null && scriptdir=$(pwd) && popd > /dev/null

[[ ! -r "$scriptdir/categoryoptions" ]] && [[ "$1" != "updatecategories" ]] && echo "Categories file missing" && exit 2

mkdir -p $workdir

token=""
category=""

aurlogin() {
    if [[ -r "~/.config/auruploader.config" ]];then
        source ~/.config/auruploader.config
    fi

    [[ -z "$user" ]] && printf "Input username: " && read user
    [[ -z "$pass" ]] && printf "Input password: " && read pass

    printf "Logging in as '$user'..."
    curl -sc "$workdir/aur.cookies" -d "user=${user}&passwd=${pass}&remember_me=on" https://aur.archlinux.org/login/ &>/dev/null
    curl -sb "$workdir/aur.cookies" https://aur.archlinux.org | grep "Logout" > /dev/null && echo "Success" || echo "Failed"
}

gettoken() {
    echo "Getting token..."
    token=$(curl -sb "$workdir/aur.cookies" https://aur.archlinux.org/submit/ | grep 'name="token"' | sed 's/.*value="\(.*\)".*/\1/')
    [[ -z "$token" ]] && aurlogin && token=$(curl -sb "$workdir/aur.cookies" https://aur.archlinux.org/submit/ | grep 'name="token"' | sed 's/.*value="\(.*\)".*/\1/')
    [[ -z "$token" ]] && echo "Token could not be retrieved." && exit 1
}

printcategories() {
    for i in $(cat $scriptdir/categoryoptions);do
        printf "$(echo $i | sed "s/.*,//") "
    done
    echo
}

updatecategories() {
    x=$(curl -sb "$workdir/aur.cookies" https://aur.archlinux.org/submit/ | sed -n '/<select.*id=.id_category.*/b br
                    b
                    : br
                    s|\(<select.*id=.id_category.*</select>\)|\1|p
                    t
                    N
                    b br')
    y=$(echo $x | sed "s|<[^<]*\(<option.*</option>\).*|\1|" | tr -d ' ' | tr '[A-Z]' '[a-z]' | sed -n "s|<optionvalue=.\([0-9]*\).>\([a-z0-9A-Z ]*\)</option>|\1,\2;|gp" | tr ';' '\n')
    echo > $scriptdir/categoryoptions
    for i in $y;do
        echo "$i" >> $scriptdir/categoryoptions
    done
}

getcategoryid() {
    [[ -z "$1" ]] && category=1 && return
    for i in $(cat $scriptdir/categoryoptions);do
        echo $i | grep "$1" > /dev/null && category=$(echo $i | sed "s/\([0-9]*\).*/\1/")
    done
    [[ -z "$category" ]] && category=1
}

case "$1" in
updatecategories)
    echo "Downloading all categories..."
    gettoken
    updatecategories
    printcategories
    ;;
printcategories)
    printcategories
    ;;
getcategoryid)
    getcategoryid $2
    echo $category
    ;;
*)
    gettoken
    echo "Uploading file $(basename $1)..."
    getcategoryid $2
    curl -b "$workdir/aur.cookies" -F pkgsubmit=1 -F token="$token" -F category="$category" -F pfile="@$1" -o $workdir/output.html https://aur.archlinux.org/submit/
    cat $workdir/output.html | grep "pkgoutput" || echo "Success"
    ;;
esac
