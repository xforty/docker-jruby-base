#!/bin/bash

set -e

cd /srv/app

if [ -e log ]
then
  rm -rf log
fi
mkdir log
chown app log

setuser app bash -lc 'bundle install --deployment'

TMP="$(mktemp -d)"
setuser app bash -lc "foreman export -d /srv/app -u app -p 80 runit '$TMP'"
mv "$TMP"/* /etc/service
rmdir "$TMP"
