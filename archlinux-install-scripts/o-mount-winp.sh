
windowsdev=/dev/sda4

if [ -n "$windowsdev" ];then
    echo "Mounting xfiles from $windowsdev..."
    mkdir -p /mnt/{windows,xfiles}
    mount -t ntfs -o ro,noatime $windowsdev /mnt/xfiles
fi
lsblk -f
echo "Done."
