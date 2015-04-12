#!/bin/bash

set -e

cd /home/app/webapp

if [ -e log ]
then
  rm -rf log
fi
mkdir /home/app/webapp/log
chown app /home/app/webapp/log

setuser app bash -lc 'cd /home/app/webapp && bundle install --deployment'

TMP="$(mktemp -d)"
setuser app bash -lc "foreman export -d /home/app/webapp -u app -p 80 runit '$TMP'"
mv "$TMP"/* /etc/service
rmdir "$TMP"
