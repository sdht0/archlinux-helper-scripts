
GPATH=/home/lfiles/dev/archlinux-logs/a

[[ -n "$1" ]] && GPATH="$1"

pushd $GPATH > /dev/null
for d in *;do
    echo "***$d***"
    source ./$d/PKGBUILD
    echo "${depends[@]}"
    echo "${makedepends[@]}"
#     for i in $depends;do
#         printf "$i "
#     done
#     for i in $makedepends;do
#         printf "$i "
#     done
    printf "\n"
done
popd > /dev/null