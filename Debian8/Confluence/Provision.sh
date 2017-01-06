apt-get -y install varnish

sed -i -e "s/6081/80/" /lib/systemd/system/varnish.service
sed -i -e "s/localhost:6082/:6082/" /lib/systemd/system/varnish.service
systemctl daemon-reload
systemctl restart varnish

cd /root
curl -O https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-6.0.3-x64.bin

