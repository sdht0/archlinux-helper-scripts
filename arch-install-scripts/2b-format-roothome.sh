# Use 'fdisk /dev/sda' to create partitions

rootdev=/dev/sda6
swapdev=/dev/sda5
homedev=/dev/sda7
otherdev=/dev/sda8

umount $otherdev $homedev $rootdev
lsblk -f
if [ -n "$rootdev" ];then
    echo "Setting up root on '$rootdev'..."
    mkfs.ext4 -L linux $rootdev
fi && \
if [ -n "$homedev" ];then
    echo "Setting up home on '$homedev'..."
    mkfs.ext4 -L home $homedev
fi && \
if [ -n "$swapdev" ];then
    echo "Setting up swap on '$swapdev'..."
    swapoff $swapdev
    mkswap -L swap $swapdev && \
    swapon $swapdev
fi && \
echo "Done."
