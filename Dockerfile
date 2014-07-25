FROM            ubuntu:latest
MAINTAINER      platform@shopkeep.com

ADD     sslsplit    /etc/sslsplit
VOLUME  ["/var/sslsplit"]

RUN     apt-get update
#RUN     apt-get -y upgrade

RUN     apt-get -y install wget build-essential iptables

WORKDIR     /tmp
RUN         wget  http://mirror.roe.ch/rel/sslsplit/sslsplit-0.4.7.tar.bz2
RUN         tar jxvf sslsplit-0.4.7.tar.bz2
WORKDIR     /tmp/sslsplit-0.4.7
RUN         apt-get -y install libssl-dev libevent-dev
RUN         make
RUN         make install
RUN         mkdir /tmp/sslsplit

#RUN         apt-get -y purge wget build-essential
#RUN         apt-get -y autoremove

#RUN         sysctl -w net.ipv4.ip_forward=1
#RUN         sudo iptables -t nat -F
#RUN         sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080
#RUN         sudo iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-ports 8443
#RUN         sudo iptables -t nat -A PREROUTING -p tcp --dport 587 -j REDIRECT --to-ports 8443
#RUN         sudo iptables -t nat -A PREROUTING -p tcp --dport 465 -j REDIRECT --to-ports 8443
#RUN         sudo iptables -t nat -A PREROUTING -p tcp --dport 993 -j REDIRECT --to-ports 8443

EXPOSE      80 443 587 465 993

ENTRYPOINT  /tmp/sslsplit-0.4.7/sslsplit -D \
                -l /var/sslsplit/connections.log \
                -j /var/sslsplit \
                -S /var/sslsplit/logdir/ \
                -k /etc/sslsplit/ca.key \
                -c /etc/sslsplit/ca.crt \
                 ssl 0.0.0.0 8443 \
                    tcp 0.0.0.0 8080

