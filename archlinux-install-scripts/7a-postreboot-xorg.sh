echo "Install xorg..." && \
pacman -Syu --noconfirm \
            xorg-server xorg-server-utils xf86-input-synaptics \
            mesa xf86-video-ati lib32-ati-dri \
            xorg-xinit xorg-twm xorg-xclock xterm && \
echo "Done. Execute 'startx' [after rebooting if in chroot] to test."
