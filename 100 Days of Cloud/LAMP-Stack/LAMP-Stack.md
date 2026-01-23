xFusionCorp Industries is planning to host a WordPress website on their infra in Stratos Datacenter.

They have already done infrastructure configuration—for example, on the storage server they already have a shared directory /vaw/www/html that is mounted on each app host under /var/www/html directory.

Please perform the following steps to accomplish the task: 

a. Install httpd, php and its dependencies on all app hosts.  
b. Apache should serve on port 8084 within the apps.  
c. Install/Configure MariaDB server on DB Server.  
d. Create a database named `kodekloud_db1` and create a database user named `kodekloud_tim` identified as password `ksH85UJjhb`. Further make sure this newly created user is able to perform all operation on the database you created.  
e. Finally you should be able to access the website on LBR link, by clicking on the App button on the top bar. You should see a message like `App is able to connect to the database using user kodekloud_tim`.

Solution:

Create database and user:

```
ssh peter@stdb01
sudo yum install mariadb-server mariadb -y
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo mysql -u root
MariaDB> create database kodekloud_db1;
MariaDB> grant all privileges on kodekloud_db1.* TO 'kodekloud_tim'@'%' identified by 'ksH85UJjhb';
MariaDB> flush privileges;
```

Create installConfig.sh file and transfer it to all web servers

```
#! /bin/bash
sudo yum install httpd -y
sudo yum install php -y php-mysqlnd -y php-pdo -y php-gd -y php-mbstring -y
sudo systemctl start httpd
sudo systemctl enable httpd

```

```
scp -r home/thor/installConfig.sh tony@stapp01:/home/tony
scp -r home/thor/installConfig.sh steve@stapp02:/home/steve
scp -r home/thor/installConfig.sh banner@stapp03:/home/banner

```

Login to each web server and run this shell file

```
./installConfig.sh

```

Change port of Apache in /etc/httpd/conf/httpd.conf

```
Listen 80 -----> 8084
sudo systemctl restart httpd
curl http://localhost:8084
```
