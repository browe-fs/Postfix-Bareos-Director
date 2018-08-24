#!/usr/bin/env bash
set -e

echo Pre-Docker container prep

###Docker container prep
mv /etc/mysql/my.cnf /etc/mysql/my.cnf.backup
cp /etc/bareos/misc/my.cnf /etc/mysql

echo Docker container configuration successful.

###Bareos director run command 
/usr/sbin/bareos-dir -c /etc/bareos/bareos-dir.conf

echo Bareos director run command was succesful.

###Postfix script
/opt/install.sh;/usr/bin/supervisord -c /etc/supervisor/supervisord.conf

#keep container alive
tail -f /dev/null
