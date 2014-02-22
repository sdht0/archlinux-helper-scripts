echo "Installing kde..." && \
pacman -S --needed alsa-utils alsa-plugins pulseaudio pulseaudio-alsa lib32-alsa-plugins lib32-libpulse gstreamer0.10-plugins \
                    kde-meta-kdebase kde-meta-kdemultimedia kdeedu-ktouch kde-meta-kdeadmin kde-meta-kdeartwork kde-meta-kdegraphics \
                    kde-meta-kdeplasma-addons kde-meta-kdesdk kde-meta-kdeutils \
                    appmenu-qt oxygen-gtk3 oxygen-gtk2 kde-gtk-config gtk3 ktorrent konversation ksshaskpass \
                    networkmanager kdeplasma-applets-plasma-nm usb_modeswitch wvdial mobile-broadband-provider-info \
                    bluez bluez-utils bluedevil \
                    cups cups-pdf kdeutils-print-manager && \
systemctl enable kdm && \
systemctl enable NetworkManager && \
systemctl enable ModemManager && \
systemctl enable bluetooth && \
systemctl enable cups && \
echo "Done."
