#! /bin/bash

yum install iptables-services -y
systemctl start iptables && systemctl enable iptables
iptables -I INPUT 1 -p tcp --dport 3004 -s 172.16.238.14 -j ACCEPT
iptables -A INPUT -p tcp --dport 3004 -j DROP
iptables-save > /etc/sysconfig/iptables