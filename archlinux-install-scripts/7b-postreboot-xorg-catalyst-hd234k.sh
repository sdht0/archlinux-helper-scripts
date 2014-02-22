echo "Adding additional repos..." && \
sed -i "s|\(#\[testing\].*\)|[xorg112]\nServer = http://mirror.rts-informatique.fr/archlinux-catalyst/repo/xorg112/$arch\nServer = http://catalyst.wirephire.com/repo/xorg112/$arch\nServer = http://70.239.162.206/catalyst-mirror/repo/xorg112/$arch\n\n[catalyst-hd234k]\nServer = http://mirror.rts-informatique.fr/archlinux-catalyst/repo/catalyst-hd234k/$arch\nServer = http://catalyst.wirephire.com/repo/catalyst-hd234k/$arch\nServer = http://70.239.162.206/catalyst-mirror/repo/catalyst-hd234k/$arch\n\n\1|" /etc/pacman.conf && \
pacman-key --keyserver pgp.mit.edu --recv-keys 0xabed422d653c3094 && \
pacman-key --lsign-key 0xabed422d653c3094 && \
echo "Install xorg..." && \
pacman -S --needed xorg-server xorg-xinit xorg-server-utils \
            mesa xf86-input-synaptics catalyst-hook lib32-catalyst-utils \
            xorg-twm xorg-xclock xterm \
            ttf-dejavu ttf-freefont ttf-liberation ttf-ubuntu-font-family ttf-droid gsfonts && \
aticonfig --initial && \
echo "blacklist radeon" > /etc/modprobe.d/radeon.conf && \
sed "s/GRUB_CMDLINE_LINUX=\"\(.*\)\"/GRUB_CMDLINE_LINUX=\"nomodeset \1\"/" /etc/default/grub && \
grub-mkconfig -o /boot/grub/grub.cfg && \
echo "Done. Execute 'startx' [after rebooting if in chroot] to test."