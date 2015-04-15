FROM phusion/passenger-customizable
MAINTAINER xforty technologies "xforty.com"

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN setuser app gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN bash -c 'echo "app ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
RUN setuser app sh -c 'curl -sSL https://get.rvm.io | bash -s stable --ruby=jruby-9.0.0.0'
RUN sed -i '$ d' /etc/sudoers
RUN setuser app bash -lc 'gem install foreman bundler'

RUN rm -f /etc/service/nginx/down
ADD nginx.conf /etc/nginx/sites-available/default

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD init-app.sh /root/init-app.sh
ADD runit /root/runit

ONBUILD ADD . /srv/app
ONBUILD RUN bash /root/init-app.sh
