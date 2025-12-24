Our monitoring tool has reported an issue in Stratos Datacenter. One of our app servers has an issue, as its Apache service is not reachable on port 8088 (which is the Apache port).

The service itself could be down, the firewall could be at fault, or something else could be causing the issue.

Use tools like telnet, netstat, etc. to find and fix the issue. Also make sure Apache is reachable from the jump host without compromising any security settings.  
Once fixed, you can test the same using command curl http://stapp01:8088 command from jump host.

Solution:

```
ssh tony@stapp01
sudo su
netstat -tulpn | grep 8088
kill -9 491 (in my case 491 sendmail)
systemctl restart httpd
systemctl status httpd
sudo iptables -I INPUT -p tcp -m tcp --dport 8088 -j ACCEPT  && sudo iptables-save > /etc/sysconfig/iptables &&  cat /etc/sysconfig/iptables
```
