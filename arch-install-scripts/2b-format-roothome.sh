umount /dev/sda{8,7,6}
swapoff /dev/sda5
lsblk -f && \
echo "Formatting /dev/sda6..." && \
mkfs.ext4 -L linux /dev/sda6 && \
echo "Formatting /dev/sda7..." && \
mkfs.ext4 -L home /dev/sda7 && \
echo "Making swap on /dev/sda5..." && \
mkswap -L swap /dev/sda5 && \
swapon /dev/sda5 && \
echo "Done."
