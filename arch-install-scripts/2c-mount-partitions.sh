echo "Mounting partitons..." && \
mount /dev/sda6 /mnt && \
mkdir -p /mnt/{home,windows,xfiles} && \
mount /dev/sda7 /mnt/home && \
mkdir -p /mnt/home/lfiles && \
mount /dev/sda8 /mnt/home/lfiles && \
lsblk -f && \
ls -a /mnt/home && \
ls -a /mnt/home/lfiles && \
echo "Done."
