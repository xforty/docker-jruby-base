#!/bin/bash

set -e

cd /srv/app

mkdir .bundle vendor
chown app .bundle vendor
setuser app bash -lc 'bundle install --deployment'
chown root -R .bundle vendor

TMP="$(setuser app mktemp -d)"
setuser app bash -lc "foreman export -d /srv/app -u app -p 8000 runit '$TMP'"
sed -i "s|$TMP|/etc/service|g" "$TMP"/*/run
mv "$TMP"/* /etc/service
rmdir "$TMP"
