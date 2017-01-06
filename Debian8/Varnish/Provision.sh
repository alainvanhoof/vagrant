apt-get -y install varnish apache2

sed -i -e "s/80/8080/" /etc/apache2/ports.conf
sed -i -e "s/6081/80/" /lib/systemd/system/varnish.service
sed -i -e "s/localhost:6082/:6082/" /lib/systemd/system/varnish.service
systemctl daemon-reload
systemctl restart apache2
systemctl restart varnish

