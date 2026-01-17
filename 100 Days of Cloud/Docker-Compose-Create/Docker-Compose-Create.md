The Nautilus application development team shared static website content that needs to be hosted on the httpd web server using a containerised platform. The team has shared details with the DevOps team, and we need to set up an environment according to those guidelines. Below are the details:

a. On App Server 3 in Stratos DC create a container named httpd using a docker compose file /opt/docker/docker-compose.yml (please use the exact name for file).

b. Use httpd (preferably latest tag) image for container and make sure container is named as httpd; you can use any name for service.

c. Map 80 number port of container with port 5001 of docker host.

d. Map container's /usr/local/apache2/htdocs volume with /opt/data volume of docker host which is already there. (please do not modify any data within these locations).

Solution :

1. SSH into App Server and become ROOT user

```
ssh banner@stapp03
sudo su
```

2. Change directory into /opt/docker/

```
cd /opt/docker/
```

3. Create Docker-Compose file using vim

```
vim docker-compose.yml
version: '3'
services:
    httpd:
      volumes:
        - /opt/data:/usr/local/apache2/htdocs
      image: httpd:latest
      container_name: httpd
      ports:
        - 5001:80
```

4. Run docker file

```
docker compose up --build -d
```

5. To check docker container is running or not

```
docker ps
```
