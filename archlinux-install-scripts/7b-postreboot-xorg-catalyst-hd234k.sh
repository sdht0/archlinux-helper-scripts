echo "Adding additional repos..." && \
grep 'xorg112' /etc/pacman.conf || sed -i 's|\(#\[testing\].*\)|[xorg112]\n\
Server = http://mirror.rts-informatique.fr/archlinux-catalyst/repo/xorg112/$arch\n\
Server = http://catalyst.wirephire.com/repo/xorg112/$arch\n\
Server = http://70.239.162.206/catalyst-mirror/repo/xorg112/$arch\n\n\
[catalyst-hd234k]\n\
Server = http://mirror.rts-informatique.fr/archlinux-catalyst/repo/catalyst-hd234k/$arch\
\nServer = http://catalyst.wirephire.com/repo/catalyst-hd234k/$arch\n\
Server = http://70.239.162.206/catalyst-mirror/repo/catalyst-hd234k/$arch\n\n\
\1|' /etc/pacman.conf && \
echo "Adding catalyst repo keys..." && \
pacman-key --keyserver pgp.mit.edu --recv-keys 0xabed422d653c3094 && \
pacman-key --lsign-key 0xabed422d653c3094 && \
echo "Install xorg with catalyst..." && \
pacman -Rc --noconfirm xf86-input-evdev && \
pacman -Syu --needed --noconfirm xorg-server xorg-xinit xorg-server-utils \
            mesa xf86-input-synaptics catalyst-hook catalyst-utils lib32-catalyst-utils \
            xorg-twm xorg-xclock xterm \
            ttf-dejavu ttf-freefont ttf-liberation ttf-ubuntu-font-family ttf-droid gsfonts && \
echo "Configuring ati..." && \
aticonfig --initial && \
echo "Blacklisting radeon..." && \
echo "blacklist radeon" > /etc/modprobe.d/blacklist-radeon.conf && \
echo "Adding nomodeset to kernel parameters..." && \
sed -i "s/GRUB_CMDLINE_LINUX=\"\(.*\)\"/GRUB_CMDLINE_LINUX=\"nomodeset \1\"/" /etc/default/grub && \
echo "Creating new grub config..." && \
grub-mkconfig -o /boot/grub/grub.cfg && \
echo "Done. Execute 'startx' [after rebooting if in chroot] to test."