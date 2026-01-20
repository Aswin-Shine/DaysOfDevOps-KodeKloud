The Nautilus DevOps team is conducting application deployment tests on selected application servers. They require a nginx container deployment on Application Server 3. 

Complete the task with the following instructions: 

1. On Application Server 3 create a container named nginx_3 using the nginx image with the alpine tag. Ensure container is in a running state

Solution : 
1. SSH into app server
```
ssh banner@stapp03
sudo su 
```
2. Install Nginx using docker 
```
docker run -d --name nginx_3 nginx:alpine
```