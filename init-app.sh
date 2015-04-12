#!/bin/bash

set -e

cd /srv/app

mkdir .bundle vendor
chown app .bundle vendor
setuser app bash -lc 'bundle install --deployment'
chown root -R .bundle vendor

TMP="$(setuser app mktemp -d)"
setuser app bash -lc "foreman export -d /srv/app -u app -p 80 runit '$TMP'"
mv "$TMP"/* /etc/service
rmdir "$TMP"
