apt-get update
apt-get install -y
# Le -y confirme que vous souhaitez télécharger et installer le paquet que vous avez spécifié
# Wget est un programme en ligne de commande non interactif de téléchargement de fichiers depuis le Web. Il supporte les protocoles HTTP, HTTPS et FTP ainsi que le téléchargement au travers des proxies HTTP.
apt-get install -y wget
apt-get install -y nginx
# php-fpm est une interface SAPI( Server Application Programming Interface) permettant la communication entre un serveur Web et PHP, basée sur le protocole FastCGI.
# FastCGI est une technique permettant la communication entre un serveur HTTP et un logiciel indépendant
apt-get install -y php-fpm php-mysql
apt-get install -y mariadb-server
apt-get install -y php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
service nginx start 
mv nginx.conf /etc/nginx/sites-available/nginx.conf
# symlink to enable our nginx.conf
ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/  
# desactiver le fichier par défaut (au cas ou)
unlink /etc/nginx/sites-enabled/default                                
mkdir var/www/mysite
wget -c https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
mv wordpress/* var/www/mysite
# donner tout les acces a wordpress sur site / ce connecter par ex. a une base de donner
mv wp-config.php var/www/mysite 
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz
tar xvf phpMyAdmin-4.9.0.1-english.tar.gz
mkdir /var/www/mysite/phpmyadmin
mv phpMyAdmin-4.9.0.1-english/* /var/www/mysite/phpmyadmin/
mv start.sql /var/www/
service mysql start
mysql < /var/www/start.sql
# création de certifica d'authentification 
openssl req -x509 -out localhost.crt -keyout localhost.key \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=localhost' -extensions EXT -config <( \
   printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
mv localhost.crt /etc/ssl/certs/
mv localhost.key /etc/ssl/certs/
service nginx restart
service php7.3-fpm start
service mysql restart