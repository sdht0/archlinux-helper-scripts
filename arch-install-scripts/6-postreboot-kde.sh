echo "Installing kde..." && \
pacman -S --needed alsa-utils alsa-plugins pulseaudio pulseaudio-alsa lib32-alsa-plugins lib32-libpulse gstreamer0.10-plugins \
                    kde-meta appmenu-qt oxygen-gtk3 oxygen-gtk2 kde-gtk-config gtk3 ktorrent konversation \
                    networkmanager kdeplasma-applets-plasma-nm usb_modeswitch wvdial mobile-broadband-provider-info \
                    bluez bluez-utils bluedevil \
                    cups cups-pdf kdeutils-print-manager  \
                    ttf-dejavu ttf-freefont ttf-liberation ttf-ubuntu-font-family ttf-droid gsfonts
systemctl enable kdm
systemctl enable NetworkManager
systemctl enable ModemManager
systemctl enable bluetooth
systemctl enable cupsd
echo "Done."
