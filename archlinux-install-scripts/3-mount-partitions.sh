rootdev=/dev/sda6
swapdev=/dev/sda5
homedev=/dev/sda7
otherdev=/dev/sda8
windowsdev=/dev/sda4

if [ -n "$rootdev" ];then
    echo "Mounting root from $rootdev..."
    mount $rootdev /mnt
fi && \
if [ -n "$homedev" ];then
    echo "Mounting home from $homedev..."
    mkdir -p /mnt/home
    mount $homedev /mnt/home
fi && \
if [ -n "$otherdev" ];then
    echo "Mounting lfiles from $otherdev..."
    mkdir -p /mnt/home/lfiles
    mount $otherdev /mnt/home/lfiles
fi && \
if [ -n "$windowsdev" ];then
    echo "Mounting xfiles from $windowsdev..."
    mkdir -p /mnt/{windows,xfiles}
    mount -t ntfs -o ro,noatime $windowsdev /mnt/xfiles
fi
lsblk -f
echo "Done."
