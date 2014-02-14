serverroot=/home/lfiles/www && \
echo "Editing httpd.conf..." && \
sed -i \
    -e "s|^ServerAdmin.*|ServerAdmin sh.siddhartha@gmail.com|" \
    -e 's|^DocumentRoot.*|DocumentRoot "'"$serverroot"'"|' \
    -e 's|<Directory "/srv/http">|<Directory "'"$serverroot"'">|' \
    -e 's|^Include conf/extra/httpd-autoindex.conf|#Include conf/extra/httpd-autoindex.conf|' \
    -e 's|^Include conf/extra/httpd-userdir.conf|#Include conf/extra/httpd-userdir.conf|' \
    -e "/^#MIMEMagicFile/ s,#,," httpd.conf && \
sed -i -e '/^<Directory "'"$(echo $serverroot | sed "s|/|\\\/|g")"'">/b br
     b
     : br
     s|^\(<Directory "'"$serverroot"'">.*\)Options Indexes FollowSymLinks|\1Options -Indexes FollowSymLinks MultiViews|
     t
     N
     b br' httpd.conf && \
sed -i -e '/^<Directory "'"$(echo $serverroot | sed "s|/|\\\/|g")"'">/b br
     b
     : br
     s|^\(<Directory "'"$serverroot"'">.*\)AllowOverride None|\1AllowOverride All|
     t
     N
     b br' httpd.conf
