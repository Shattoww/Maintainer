#!/bin/bash

cd /opt/mft/processors/visadps/incoming 

###Here we use parameter expansion to call the default DAY variable if no argument is specified.

#DAY=$(date +%m%d)
DAY=${1:-$(date +%m%d)}
MONTHLY=$(date +%y%m)

#list_commands=""
#  list_commands="$list_commands
#  get -a VSN.D$DAY
#  get -a ISO.D$DAY
#  get -a EXC.D$DAY
#  get -a BAL.D$DAY
#  get -a ILK.D$DAY
#  get -a QTR.D$MONTHLY
#  get -a MMM.D$MONTHLY
#  get -a MTH.D$MONTHLY
#  get -a AUD.D$DAY"

list_commands=""
  list_commands="$list_commands
  get -a VSN.D$DAY
  "

lftp <<EOF
set ftp:ssl-force on
set ssl:verify-certificate off
set ftp:ssl-protect-data on
set ftp:ssl-protect-list yes
set ftp:ssl-auth SSL
set port-range 28000--29999
set net:idle 3600
open -u FTPD0537,V8CT4W5Y 198.217.221.3
cd home
$list_commands
exit
EOF


list_commands=""
  list_commands="$list_commands
  get -a ISO.D$DAY"

lftp <<EOF
set ftp:ssl-force on
set ssl:verify-certificate off
set ftp:ssl-protect-data on
set ftp:ssl-protect-list yes
set ftp:ssl-auth SSL
set port-range 28000--29999
set net:idle 3600
open -u FTPD0537,V8CT4W5Y 198.217.221.3
cd home
$list_commands
exit
EOF

list_commands=""
  list_commands="$list_commands
  get -a EXC.D$DAY
  "

lftp <<EOF
set ftp:ssl-force on
set ssl:verify-certificate off
set ftp:ssl-protect-data on
set ftp:ssl-protect-list yes
set ftp:ssl-auth SSL
set port-range 28000--29999
set net:idle 3600
open -u FTPD0537,V8CT4W5Y 198.217.221.3
cd home
$list_commands
exit
EOF

list_commands=""
  list_commands="$list_commands
  get -a BAL.D$DAY
  "

lftp <<EOF
set ftp:ssl-force on
set ssl:verify-certificate off
set ftp:ssl-protect-data on
set ftp:ssl-protect-list yes
set ftp:ssl-auth SSL
set port-range 28000--29999
set net:idle 3600
open -u FTPD0537,V8CT4W5Y 198.217.221.3
cd home
$list_commands
exit
EOF

list_commands=""
  list_commands="$list_commands
  get -a ILK.D$DAY
  "

lftp <<EOF
set ftp:ssl-force on
set ssl:verify-certificate off
set ftp:ssl-protect-data on
set ftp:ssl-protect-list yes
set ftp:ssl-auth SSL
set port-range 28000--29999
set net:idle 3600
open -u FTPD0537,V8CT4W5Y 198.217.221.3
cd home
$list_commands
exit
EOF

list_commands=""
  list_commands="$list_commands
  get -a QTR.D$MONTHLY
  "

lftp <<EOF
set ftp:ssl-force on
set ssl:verify-certificate off
set ftp:ssl-protect-data on
set ftp:ssl-protect-list yes
set ftp:ssl-auth SSL
set port-range 28000--29999
set net:idle 3600
open -u FTPD0537,V8CT4W5Y 198.217.221.3
cd home
$list_commands
exit
EOF

list_commands=""
  list_commands="$list_commands
  get -a MMM.D$MONTHLY
  "

lftp <<EOF
set ftp:ssl-force on
set ssl:verify-certificate off
set ftp:ssl-protect-data on
set ftp:ssl-protect-list yes
set ftp:ssl-auth SSL
set port-range 28000--29999
set net:idle 3600
open -u FTPD0537,V8CT4W5Y 198.217.221.3
cd home
$list_commands
exit
EOF

list_commands=""
  list_commands="$list_commands
  get -a MTH.D$MONTHLY
  "

lftp <<EOF
set ftp:ssl-force on
set ssl:verify-certificate off
set ftp:ssl-protect-data on
set ftp:ssl-protect-list yes
set ftp:ssl-auth SSL
set port-range 28000--29999
set net:idle 3600
open -u FTPD0537,V8CT4W5Y 198.217.221.3
cd home
$list_commands
exit
EOF

list_commands=""
  list_commands="$list_commands
  get -a AUD.D$DAY"

lftp <<EOF
set ftp:ssl-force on
set ssl:verify-certificate off
set ftp:ssl-protect-data on
set ftp:ssl-protect-list yes
set ftp:ssl-auth SSL
set port-range 28000--29999
set net:idle 3600
open -u FTPD0537,V8CT4W5Y 198.217.221.3
cd home
$list_commands
exit
EOF


list_commands=""
  list_commands="$list_commands
  get -a MT3.D$DAY"

lftp <<EOF
set ftp:ssl-force on
set ssl:verify-certificate off
set ftp:ssl-protect-data on
set ftp:ssl-protect-list yes
set ftp:ssl-auth SSL
set port-range 28000--29999
set net:idle 3600
open -u FTPD0537,V8CT4W5Y 198.217.221.3
cd home
$list_commands
exit
EOF

####chown visadps:nobody /home/visadps/incoming/*
chmod 660 /opt/mft/processors/visadps/incoming/*

cd /opt/mft/processors/visadps/incoming


# Extract B of I data and prepare for upload to them

for i in BAL EXC AUD VSN ILK
do
  /usr/local/etc/BOFI-dps-extract.py -i /opt/mft/processors/visadps/incoming/$i.D$DAY | grep -v "FIRST CALIFORNIA" > /opt/mft/processors/visadps/bofi-reports/BOFI-VISA-DPS-$i.D$DAY
done

/usr/bin/find /opt/mft/processors/visadps/bofi-reports/BOFI* -mtime +45 -exec rm {} \;

# Extract META report data and dump into META outgoing folder and upload to META

for i in BAL EXC AUD VSN ILK
do
  /usr/local/etc/vsn-extract.py -i /opt/mft/processors/visadps/incoming/$i.D$DAY | grep -v "FIRST CALIFORNIA" > /opt/mft/processors/visadps/meta/outgoing/VISA-DPS-$i.D$DAY
chmod 644 /opt/mft/processors/visadps/meta/outgoing/VISA-DPS-$i.D$DAY
##########sftp -b /dev/stdin globalcash0410@sftp.metatransfer.com <<EOF
##########cd processing/mcr/inbound
##########put /opt/mft/processors/visadps/incoming/meta/outgoing/VISA-DPS-$i.D$DAY
##########bye
##########EOF
done

/usr/bin/find /opt/mft/processors/visadps/meta/outgoing/VISA-DPS* -mtime +7 -exec rm {} \;

/usr/local/etc/aud-extract2.pl </opt/mft/processors/visadps/incoming/AUD.D$DAY > /opt/mft/processors/visadps/incoming/AUD-NETWORK_SUMMARY-$DAY.txt
