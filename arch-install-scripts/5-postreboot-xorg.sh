echo "Install xorg..." && \
pacman -S xorg-server xorg-xinit xorg-server-utils mesa xf86-video-ati lib32-ati-dri xf86-input-synaptics xorg-twm xorg-xclock xterm && \
startx && \
echo "Done."