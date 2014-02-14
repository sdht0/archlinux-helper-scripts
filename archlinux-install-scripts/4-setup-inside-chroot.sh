echo "Setting locale to 'en_US.UTF-8'..." && \
sed -i -e "/^#en_US.UTF-8 UTF-8/ s,#,," /etc/locale.gen && \
echo "Generating locale..." && \
locale-gen && \
echo LANG=en_US.UTF-8 > /etc/locale.conf && \
export LANG=en_US.UTF-8 && \
echo "Set timezone..." && \
ln -s /usr/share/zoneinfo/Asia/Kolkata /etc/localtime && \
echo "Set hardware clock..." && \
hwclock --systohc --utc && \
echo "Set hostname to 'sdh-archlinux'..." && \
echo "sdh-archlinux" > /etc/hostname && \
echo "Editing pacman conf..." && \
sed -i \
    -e "/^#UseDelta/ s,#,," \
    -e "/^#Color/ s,#,," \
    -e "/^#TotalDownload/ s,#,," \
    -e "/^#VerbosePkgLists/ s,#,," \
    -e '/^#\[multilib\]/ s,#,,' \
    -e '/^\[multilib\]/{$!N; s,#,,}' /etc/pacman.conf && \
echo "Edit pacman mirrors..." && \
nano /etc/pacman.d/mirrorlist && \
echo "Updating pacman..." && \
pacman -Syu bash-completion  && \
echo "Set root password..." && \
passwd && \
echo "Changing default shell..." && \
usermod -s /usr/bin/zsh root && \
echo "Adding user sdh..." && \
useradd -m -g users -G wheel -s /usr/bin/zsh sdh && \
echo "Generating zsh config..." && \
echo "
. /home/lfiles/.zshrc
. /home/lfiles/.bashrc
" > /home/sdh/.zshrc && \
echo "Generating bash config..." && \
echo "#
PS1='\W$ '
. /home/lfiles/.bashrc
" > /home/sdh/.bashrc && \
echo "Set sdh password..." && \
passwd sdh && \
echo "Disable PC beep..." && \
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf && \
echo "Install grub..." && \
pacman -S grub os-prober ntfs-3g dosfstools && \
grub-install --target=i386-pc --recheck /dev/sda && \
grub-mkconfig -o /boot/grub/grub.cfg && \
echo "Done."
echo "Time to reboot!"
