xFusionCorp Industries is planning to host two static websites on their infra in Stratos Datacenter. The development of these websites is still in-progress, but we want to get the servers ready. Please perform the following steps to accomplish the task:

a. Install httpd package and dependencies on app server 1.

b. Apache should serve on port 3000.

c. There are two website's backups /home/thor/blog and /home/thor/games on jump_host. Set them up on Apache in a way that official should work on the link http://localhost:3000/blog/ and cluster should work on link http://localhost:3000/games/ on the mentioned app server.

d. Once configured you should be able to access the website using curl command on the respective app server, i.e curl http://localhost:3000/blog/ and curl http://localhost:3000/games/

Solution:

```
scp /home/thor/blog/index.html tony@stapp01:/tmp/blog.html
scp /home/thor/games/index.html tony@stapp01:/tmp/games.html
ssh tony@stapp01
sudo yum install httpd -y
sudo mkdir -p /var/www/html/blog
sudo mkdir -p /var/www/html/games
sudo mv /tmp/blog.html /var/www/html/blog/index.html
sudo mv /tmp/games.html /var/www/html/games/index.html
sudo vi /etc/httpd/conf/httpd.conf
```

Change the default port to 5000 by modifying the Listen directive.

```
sudo vi /etc/httpd/conf.d/virtual_hosts.conf
```

Add below text:

```
<VirtualHost *:3000>
    DocumentRoot /var/www/html

    <Directory "/var/www/html/blog">
        AllowOverride All
        Require all granted
    </Directory>

    <Directory "/var/www/html/games">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

```
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl status httpd
curl http://localhost:3000/blog/
curl http://localhost:3000/games/
exit
```
