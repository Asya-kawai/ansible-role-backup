#!/bin/sh

umask 077

# create backup dir if not exist.
[ ! -d /var/backup ] && mkdir /var/backup || true

# nginx
[ ! -d /var/backup/nginx ] && mkdir /var/backup/nginx || true
sh /opt/bin/dir_backup.sh /usr/local/etc/nginx/ /var/backup/nginx/

# etc
[ ! -d /var/backup/etc ] && mkdir /var/backup/etc || true
sh /opt/bin/dir_backup.sh /etc/ /var/backup/etc/

# opt
[ ! -d /var/backup/opt ] && mkdir /var/backup/opt || true
sh /opt/bin/dir_backup.sh /opt/bin/ /var/backup/opt/

exit 0
