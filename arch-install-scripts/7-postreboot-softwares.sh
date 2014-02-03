randpw(){ < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo;}
echo "Installing packages..." && \
pacman -S --needed firefox tomboy flashplugin git subversion tsocks wget chromium vlc gimp linuxdcpp \
                    ntp virtualbox virtualbox-guest-iso googlecl s3cmd imagemagick graphviz unrar unzip zip p7zip wireshark-gtk \
                    libreoffice libreoffice-extension-pdfimport libreoffice-extension-presenter-screen libreoffice-extension-presentation-minimizer \
                    aspell aspell-en hunspell hunspell-en hyphen hyphen-en artwiz-fonts \
                    qt5 qt5-doc python python-beautifulsoup4 python2-beautifulsoup4 python2-pyqt mysql-python qtcreator cmake gdb valgrind \
                    kdevelop kdevelop-python kdevelop-php racket ghc cabal-install jre7-openjdk jdk7-openjdk \
                    apache php php-apache mariadb phpmyadmin php-mcrypt php-gd \
                    openssh nmap rsync devtools ccache skype pidgin ksshaskpass && \
echo "Setting up ntp..." &&
systemctl enable ntpd && \
systemctl start ntpd && \
echo "Setting up git..." &&
git config --global user.name "Siddhartha Sahu" && \
git config --global user.email "sh.siddhartha@gmail.com" && \
echo "Adding sdh to wireshark" &&
gpasswd -a sdh wireshark && \
echo "Adding sdh to vboxusers" &&
gpasswd -a sdh vboxusers && \
echo "Setting up tsocks..." && \
echo "
server = 127.0.0.1
server_port = 9999
server_type = 5
" > /etc/tsocks.conf && \
echo "Setting up LAMP..." && \
systemctl enable httpd && \
systemctl enable mysqld && \
systemctl start httpd && \
systemctl start mysqld && \
mysql_secure_installation && \
echo "Editing httpd.conf..." && \
sed -i \
    -e "s|^ServerAdmin.*|ServerAdmin sh.siddhartha@gmail.com|" \
    -e 's|^DocumentRoot.*|DocumentRoot "/home/lfiles/www"|' \
    -e 's|<Directory "/srv/http">|<Directory "/home/lfiles/www">|' \
    -e 's|^Include conf/extra/httpd-autoindex.conf|#Include conf/extra/httpd-autoindex.conf|' \
    -e 's|^Include conf/extra/httpd-userdir.conf|#Include conf/extra/httpd-userdir.conf|' \
    -e "/^#MIMEMagicFile/ s,#,," /etc/httpd/conf/httpd.conf && \
sed -i -e '/^<Directory "\/home\/lfiles\/www">/b br
     b
     : br
     s|^\(<Directory "/home/lfiles/www">.*\)Options Indexes FollowSymLinks|\1Options Indexes FollowSymLinks MultiViews|
     t
     N
     b br' /etc/httpd/conf/httpd.conf && \
sed -i -e '/^<Directory "\/home\/lfiles\/www">/b br
     b
     : br
     s|^\(<Directory "/home/lfiles/www">.*\)AllowOverride None|\1AllowOverride All|
     t
     N
     b br' /etc/httpd/conf/httpd.conf && \
echo "Editing httpd-default.conf..." && \
sed -i \
    -e "/^ServerTokens/ s,Full,Prod," \
    -e "/^ServerSignature/ s,On,Off," /etc/httpd/conf/extra/httpd-default.conf && \
echo "Editing mime.types..." && \
sed -i \
    -e "/atomsvc$/a\
    application/x-httpd-php       php    php5" /etc/httpd/conf/mime.types && \
echo "Editing php.ini..." && \
sed -i \
    -e "s|^open_basedir =.*|open_basedir = /home/lfiles/www/:/tmp/:/usr/share/pear/:/usr/share/webapps/|" \
    -e "s|^;date.timezone =|date.timezone = Asia/Kolkata|"  \
    -e "/^;extension=gd.so/ s,;,,"  \
    -e "/^;extension=mcrypt.so/ s,;,,"  \
    -e "/^;extension=pdo_mysql.so/ s,;,,"  \
    -e "/^;extension=mysqli.so/ s,;,," /etc/php/php.ini && \
cp /etc/webapps/phpmyadmin/apache.example.conf /etc/httpd/conf/extra/httpd-phpmyadmin.conf && \
echo "

LoadModule php5_module modules/libphp5.so
Include conf/extra/php5_module.conf

# phpMyAdmin configuration
Include conf/extra/httpd-phpmyadmin.conf
" >> /etc/httpd/conf/httpd.conf && \
echo "Setting up phpmyadmin..." && \
pmapasswd=$(randpw 15) && \
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
GRANT SELECT, INSERT, UPDATE, DELETE ON phpmyadmin.* TO 'pma'@'localhost';" | mysql -u root -p && \
mysql -u root -p < /usr/share/webapps/phpMyAdmin/examples/create_tables.sql && \
sed -i \
    -e "s|^\(\$cfg\['blowfish_secret'\] =\).*|\1 '$(randpw 37)';|" \
    -e "/^\/\/ \$cfg\['Servers'\]\[\$i\]/ s,// ,,"  \
    -e "s/^\(\$cfg\['Servers'\]\[\$i\]\['auth_swekey_config'\]\)/\/\/ \1/"  \
    -e "s/\(\['controlpass'\] =\).*/\1 '$pmapasswd';/" /etc/webapps/phpmyadmin/config.inc.php && \
echo "Setting flat-volumes=no..." && \
sed -i "s/^; flat-volumes = yes/flat-volumes = no/" /etc/pulse/daemon.conf && \
echo "Editing kmixrc..." && \
sed -i \
    -e "/VolumeFeedback=false$/a\
VolumePercentageStep=3" ~/.kde4/share/config/kmixrc && \
echo "Done."