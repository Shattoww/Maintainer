#!/bin/bash
#### So cfaid user won't be needed as MFT is going to performing the encryption and decryption.
# rm -f /home/cfaid/working/*

DAY=$(date +%y%m%d)
PREFIX=MCI.AR.TO6Q.S.E0078986.D$DAY*
#cp /opt/mft/processors/mcips/production/upload/TO6Q/${PREFIX}* /opt/mft/processors/mcips/incoming/
# chown cfaid:cfaid /home/cfaid/working/*

# sudo -u cfaid /usr/bin/gpg --homedir=/home/cfaid/ -q --batch --no-tty --keyring /home/cfaid/.gnupg/pubring.gpg --secret-keyring /home/cfaid/.gnupg/secring.gpg -o /home/cfaid/working/MCIPS.TO6Q.D$DAY.txt -d /home/cfaid/working/${PREFIX}*

for file in "*$DAY"
do
	mv "$file" "${file/"$PREFIX"/MCIPS.TO6Q.D$DAY}"
done

/usr/local/etc/ips-meta-extract.pl < /opt/mft/processors/mcips/incoming/MCIPS.TO6Q.D$DAY > /opt/mft/processors/mcips/meta/outgoing/MC-IPS.TO6Q.D$DAY


#chown meta:nobody /home/meta/outgoing/MC-IPS.TO6Q.D$DAY
chmod 660 /opt/mft/processors/mcips/meta/outgoing/MC-IPS.TO6Q.D$DAY

# sftp -b /dev/stdin globalcash0410@sftp.metatransfer.com <<EOF
# cd incoming
# put /home/meta/outgoing/MC-IPS.TO6Q.D$DAY
# bye
# EOF
# done

### Commented out until we make sure everything is working
#/bin/find /opt/mft/processors/mcips/meta/outgoing/MC-IPS* -mtime +7 -exec rm {} \;

