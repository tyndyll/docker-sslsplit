#!/bin/bash

echo "Setting up NAT ipfilter rules"
sudo iptables -t nat -F
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080
sudo iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-ports 8443
sudo iptables -t nat -A PREROUTING -p tcp --dport 587 -j REDIRECT --to-ports 8443
sudo iptables -t nat -A PREROUTING -p tcp --dport 465 -j REDIRECT --to-ports 8443
sudo iptables -t nat -A PREROUTING -p tcp --dport 993 -j REDIRECT --to-ports 8443
echo "IP Rules set up"
