Day by day traffic is increasing on one of the websites managed by the Nautilus production support team. Therefore, the team has observed a degradation in website performance.

Following discussions about this issue, the team has decided to deploy this application on a high availability stack i.e on Nautilus infra in Stratos DC.

They started the migration last month and it is almost done, as only the LBR server configuration is pending. Configure LBR server as per the information given below:

a. Install nginx on LBR (load balancer) server.

b. Configure load-balancing with the an http context making use of all App Servers. Ensure that you update only the main Nginx configuration file located at /etc/nginx/nginx.conf.

c. Make sure you do not update the apache port that is already defined in the apache configuration on all app servers, also make sure apache service is up and running on all app servers.

d. Once done, you can access the website using StaticApp button on the top bar.

Solution :

```
ssh tony@stapp01

sudo ss -tulpn | grep httpd -> check for the apache port
tcp   LISTEN 0      511          0.0.0.0:lm-x      0.0.0.0:*    users:(("httpd",pid=1677,fd=3),("httpd",pid=1676,fd=3),("httpd",pid=1675,fd=3),("httpd",pid=1667,fd=3))

sudo lm-x /etc/services
lm-x   6200/tcp                # In my case this was the port

ssh loki@stlb01
sudo yum install nginx -y
sudo systemctl start nginx && sudo systemctl enable nginx
sudo systemctl status nginx
sudo vi /etc/nginx/nginx.conf
```

Add below :

```
http {
    upstream app_servers {
        server 172.16.238.10:6200;
        server 172.16.238.11:6200;
        server 172.16.238.12:6200;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://app_servers;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
sudo nginx -t -> check for configuration syntax
sudo systemctl reload nginx
```
