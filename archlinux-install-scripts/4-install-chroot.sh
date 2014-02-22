echo "Editing pacman conf..." && \
sed -i \
    -e "/^#Color/ s,#,," \
    -e "/^#TotalDownload/ s,#,," \
    -e "/^#VerbosePkgLists/ s,#,," /etc/pacman.conf && \
echo "Adding local repo address..." && \
sed -i '1s|^|Server = http://172.16.32.222/repo/archlinux_x86-64/$repo/os/$arch\n\n|' /etc/pacman.d/mirrorlist && \
echo "Installing packages..." && \
pacstrap /mnt base base-devel zsh && \
echo "Generating fstab..." && \
genfstab -U -p /mnt >> /mnt/etc/fstab && \
echo "Generating extra entries in fstab..." && \
echo "# /dev/sda4 LABEL=xfiles
UUID=C878F05278F040AC                           /xfiles                 ntfs-3g         uid=1000,gid=100,umask=003              0 0

# /dev/sda2 LABEL=windows
UUID=B6EE2ABEEE2A7731                           /windows                ntfs-3g         uid=1000,gid=100,umask=003              0 0

# /dev/sdb LABEL=sdh
UUID=1019B40C17D4A684                           /home/lfiles/sdh-hdd    ntfs-3g         uid=1000,gid=100,umask=003,nofail       0 0
" >> /mnt/etc/fstab && \
echo "Generating zsh config..." && \
echo "
. /home/lfiles/.zshrc
. /home/lfiles/.bashrc
" > /mnt/root/.zshrc && \
echo "Generating bash config..." && \
echo "
PS1='\W$ '
. /home/lfiles/.bashrc
" > /mnt/root/.bashrc && \
windowsdev=/dev/sda4 && \
if [ -n "$windowsdev" ];then
    echo "Mounting xfiles from $windowsdev..."
    mkdir -p /mnt/{windows,xfiles}
    mount -t ntfs -o ro,noatime $windowsdev /mnt/xfiles
fi
echo "Done."
