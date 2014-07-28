FROM            ubuntu:12.04
MAINTAINER      platform@shopkeep.com

ADD     sslsplit    /etc/sslsplit
ADD     iptables.sh   /tmp/iptables.sh
VOLUME  ["/var/sslsplit"]

RUN     apt-get update
RUN     apt-get -y upgrade
RUN     apt-get -y install wget build-essential

WORKDIR     /tmp
RUN         wget  http://mirror.roe.ch/rel/sslsplit/sslsplit-0.4.8.tar.bz2
RUN         tar jxvf sslsplit-0.4.8.tar.bz2
WORKDIR     /tmp/sslsplit-0.4.8
RUN         apt-get -y install libssl-dev libevent-dev
RUN         make
RUN         make install
RUN         mkdir /tmp/sslsplit

RUN         apt-get -y purge wget build-essential
RUN         apt-get -y autoremove

ENTRYPOINT  /bin/sh /tmp/iptables.sh && /tmp/sslsplit-0.4.8/sslsplit -D \
                -l /var/sslsplit/connections.log \
                -j /var/sslsplit \
                -S /var/sslsplit/logdir/ \
                -k /etc/sslsplit/ca.key \
                -c /etc/sslsplit/ca.crt \
                  ssl 0.0.0.0 8443 \
                  tcp 0.0.0.0 8080

