#! /bin/bash
sudo yum install httpd -y
sudo yum install php -y php-mysqlnd -y php-pdo -y php-gd -y php-mbstring -y
sudo systemctl start httpd
sudo systemctl enable httpd 