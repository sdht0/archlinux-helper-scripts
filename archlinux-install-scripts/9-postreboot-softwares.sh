randpw(){ < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo;}
echo "Installing packages..." && \
pacman -S --needed \
            firefox tomboy flashplugin tsocks chromium vlc gimp linuxdcpp virtualbox virtualbox-guest-iso gparted mkisolinux \
            googlecl s3cmd imagemagick wireshark-gtk skype pidgin telepathy \
            libreoffice libreoffice-extension-pdfimport libreoffice-extension-presenter-screen \
            aspell aspell-en hunspell hunspell-en hyphen hyphen-en artwiz-fonts \
            qt5 qt5-doc python python-beautifulsoup4 python2-beautifulsoup4 python2-pyqt mysql-python qtcreator graphviz \
            kdevelop kdevelop-python kdevelop-php racket ghc cabal-install jre7-openjdk jdk7-openjdk \
            devtools ccache cmake gdb valgrind unrar unzip zip p7zip rsync wget git perl-net-smtp-ssl perl-mime-tools perl-authen-sasl tk bzr subversion \
            openssh ntp nmap dnsutils mtr \
            apache php php-apache mariadb phpmyadmin php-mcrypt php-gd && \
echo "Setting up ntp..." &&
systemctl enable ntpd && \
systemctl start ntpd && \
echo "Adding sdh to wireshark" &&
gpasswd -a sdh wireshark && \
echo "Setting up virtualbox..." &&
gpasswd -a sdh vboxusers && \
echo -e "vboxdrv\nvboxnetadp\nvboxnetflt\nvboxpci" > /etc/modules-load.d/virtualbox.conf && \
modprobe vboxdrv && \
modprobe vboxnetadp && \
modprobe vboxnetflt && \
modprobe vboxpci && \
echo "Setting up tsocks..." && \
echo "
server = 127.0.0.1
server_port = 9999
server_type = 5
" > /etc/tsocks.conf && \
serverroot=/home/lfiles/www && \
home=/home/sdh && \
echo "Setting flat-volumes=no..." && \
sed -i "s/^; flat-volumes = yes/flat-volumes = no/" /etc/pulse/daemon.conf && \
echo "Editing kmixrc..." && \
grep "VolumePercentageStep" $home/.kde4/share/config/kmixrc > /dev/null && \
sed -i "s/VolumePercentageStep.*/VolumePercentageStep=3/" $home/.kde4/share/config/kmixrc || \
sed -i \
    -e "/VolumeFeedback.*$/a\
VolumePercentageStep=3" $home/.kde4/share/config/kmixrc && \
echo "Setting up LAMP..." && \
systemctl enable httpd && \
systemctl enable mysqld && \
echo "Starting httpd..." && \
systemctl start httpd && \
echo "Starting mysqld..." && \
systemctl start mysqld && \
mysql_secure_installation && \
echo "Editing httpd.conf..." && \
sed -i \
    -e '\|^Include conf/extra/httpd-autoindex.conf| s,^,#,' \
    -e '\|^Include conf/extra/httpd-userdir.conf| s,^,#,' \
    -e '\|^LoadModule rewrite_module modules/mod_rewrite.so| s,^,#,' \
    -e '/unique_id_module/ s,^,#,' \
    -e 's|^DocumentRoot.*|DocumentRoot "'"$serverroot"'"|' \
    -e '/mpm_event_module/ s,event,prefork,g' \
    -e '\|^<Directory "/srv/http">|b br
        b
        : br
        s|^<Directory "/srv/http">\(.*\)Options Indexes FollowSymLinks\(.*\)AllowOverride None|<Directory "'"$serverroot"'">\1Options -Indexes +FollowSymLinks +MultiViews\2AllowOverride All|
        t
        N
        b br' /etc/httpd/conf/httpd.conf && \
echo "Editing httpd-default.conf..." && \
sed -i \
    -e "/^ServerTokens/ s,Full,Prod," \
    -e "/^ServerSignature/ s,On,Off," /etc/httpd/conf/extra/httpd-default.conf && \
echo "Editing php.ini..." && \
sed -i \
    -e "s|^open_basedir =.*|open_basedir = $serverroot/:/tmp/:/usr/share/pear/:/usr/share/webapps/|" \
    -e "s|^;date.timezone =|date.timezone = Asia/Kolkata|"  \
    -e "/^;extension=gd.so/ s,;,,"  \
    -e "/^;extension=mcrypt.so/ s,;,,"  \
    -e "/^;extension=pdo_mysql.so/ s,;,,"  \
    -e "/^;extension=mysqli.so/ s,;,," /etc/php/php.ini && \
echo "
# PHP configuration
LoadModule php5_module modules/libphp5.so
Include conf/extra/php5_module.conf" >> /etc/httpd/conf/httpd.conf && \
echo "Setting up phpmyadmin... Needs mysql root password" && \
echo 'Alias /dbp "/usr/share/webapps/phpMyAdmin"
<Directory "/usr/share/webapps/phpMyAdmin">
    DirectoryIndex index.html index.php
    AllowOverride All
    Options FollowSymlinks
    Require all granted
</Directory>' > /etc/httpd/conf/extra/httpd-phpmyadmin.conf && \
echo "
# phpMyAdmin configuration
Include conf/extra/httpd-phpmyadmin.conf" >> /etc/httpd/conf/httpd.conf && \
pmapasswd=$(randpw 20) && \
echo "CREATE USER 'pma'@'localhost' IDENTIFIED BY '$pmapasswd';
GRANT USAGE ON mysql.* TO 'pma'@'localhost' IDENTIFIED BY '$pmapasswd';
GRANT SELECT (
    Host, User, Select_priv, Insert_priv, Update_priv, Delete_priv,
    Create_priv, Drop_priv, Reload_priv, Shutdown_priv, Process_priv,
    File_priv, Grant_priv, References_priv, Index_priv, Alter_priv,
    Show_db_priv, Super_priv, Create_tmp_table_priv, Lock_tables_priv,
    Execute_priv, Repl_slave_priv, Repl_client_priv
    ) ON mysql.user TO 'pma'@'localhost';
GRANT SELECT ON mysql.db TO 'pma'@'localhost';
GRANT SELECT ON mysql.host TO 'pma'@'localhost';
GRANT SELECT (Host, Db, User, Table_name, Table_priv, Column_priv)
    ON mysql.tables_priv TO 'pma'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON phpmyadmin.* TO 'pma'@'localhost';
$(cat /usr/share/webapps/phpMyAdmin/examples/create_tables.sql)" | mysql -u root -p && \
sed -i \
    -e "s|^\(\$cfg\['blowfish_secret'\] =\).*|\1 '$(randpw 37)';|" \
    -e "/^\/\/ \$cfg\['Servers'\]\[\$i\]/ s,// ,,"  \
    -e "s/^\(\$cfg\['Servers'\]\[\$i\]\['auth_swekey_config'\]\)/\/\/ \1/"  \
    -e "s/\(\['controlpass'\] =\).*/\1 '$pmapasswd';/" /etc/webapps/phpmyadmin/config.inc.php && \
echo "Restarting httpd..." && \
systemctl restart httpd && \
echo "Done."
