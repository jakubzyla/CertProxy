#!/bin/bash

for i in `echo "show backend" | socat stdio /var/run/haproxy/admin.sock | grep -Ev "^stats$|^MASTER$|^$|^# name$" | grep "\."`; do
	echo $i
	certbot certonly \
	  --dns-ovh \
	  --dns-ovh-credentials /root/.secrets/certbot/ovh.ini \
	  -d $i \
	  --keep \
	  --dns-ovh-propagation-seconds 60
	cat "/etc/letsencrypt/live/$i/fullchain.pem" "/etc/letsencrypt/live/$i/privkey.pem" > "/etc/ssl/certbot-haproxy/$i.pem"
	sleep 3
done 


service haproxy reload
