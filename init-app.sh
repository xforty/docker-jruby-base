#!/bin/bash

set -e

cd /srv/app

chown -R app .
setuser app bash -lc 'bundle install --deployment'

echo "app ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
setuser app bash -lc "rvmsudo_secure_path=1 rvmsudo foreman export -t /root/runit -d /srv/app -u app -p 8000 runit /etc/service"
sed -i '$ d' /etc/sudoers
