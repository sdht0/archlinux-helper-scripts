echo "Install xorg..." && \
pacman -Syu --noconfirm xorg-server xorg-xinit xorg-server-utils \
            mesa xf86-video-ati lib32-ati-dri xf86-input-synaptics \
            xorg-twm xorg-xclock xterm && \
echo "Done. Execute 'startx' [after rebooting if in chroot] to test."
