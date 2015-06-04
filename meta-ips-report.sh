#!/bin/bash

rm -f /home/cfaid/working/*

DAY=$(date +%y%m%d)
PREFIX=MCI.AR.TO6Q.S.E0078986.D$DAY*
cp /home/mcips/production/upload/TO6Q/${PREFIX}* /home/cfaid/working/
chown cfaid:cfaid /home/cfaid/working/*

sudo -u cfaid /usr/bin/gpg --homedir=/home/cfaid/ -q --batch --no-tty --keyring /home/cfaid/.gnupg/pubring.gpg --secret-keyring /home/cfaid/.gnupg/secring.gpg -o /home/cfaid/working/MCIPS.TO6Q.D$DAY.txt -d /home/cfaid/working/${PREFIX}*

/usr/local/etc/ips-meta-extract.pl < /home/cfaid/working/MCIPS.TO6Q.D$DAY.txt > /home/meta/outgoing/MC-IPS.TO6Q.D$DAY

chown meta:nobody /home/meta/outgoing/MC-IPS.TO6Q.D$DAY
chmod 640 /home/meta/outgoing/MC-IPS.TO6Q.D$DAY

sftp -b /dev/stdin globalcash0410@sftp.metatransfer.com <<EOF
cd incoming
put /home/meta/outgoing/MC-IPS.TO6Q.D$DAY
bye
EOF
done

/usr/bin/find /home/meta/outgoing/MC-IPS* -mtime +7 -exec rm {} \;

