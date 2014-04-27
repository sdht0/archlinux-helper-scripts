echo "Removing additional repos..." && \
grep 'xorg112' /etc/pacman.conf && \
sed -i '\|xorg112|b br
        b
        : br
        s|\[xorg112.*testing|#\[testing|
        t
        N
        b br' /etc/pacman.conf || true && \
echo "Remove catalyst installation..." && \
pacman -Rdd catalyst-hook catalyst-utils catalyst-libgl opencl-catalyst lib32-catalyst-libgl lib32-opencl-catalyst lib32-catalyst-utils opencl-headers && \
echo "Removing xorg config..." && \
rm /etc/X11/xorg.conf || true && \
echo "Stopping catalyst service..." && \
systemctl stop catalyst-hook && \
systemctl disable catalyst-hook && \
echo "Removing module config..." && \
# rm -f /etc/modprobe.d/blacklist-radeon.conf && \
rm -f /etc/modules-load.d/catalyst.conf && \
echo "Removing nomodeset from kernel parameters..." && \
sed -i "s/[ ]*nomodeset[ ]*/ /" /boot/grub/grub.cfg && \
grep "quiet" /boot/grub/grub.cfg && \
echo "Done."