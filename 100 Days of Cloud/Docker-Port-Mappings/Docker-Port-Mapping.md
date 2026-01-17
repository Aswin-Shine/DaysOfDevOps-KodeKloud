The Nautilus DevOps team is planning to host an application on a nginx-based container. There are number of tickets already been created for similar tasks. One of the tickets has been assigned to set up a nginx container on Application Server 2 in Stratos Datacenter. Please perform the task as per details mentioned below:

a. Pull nginx:stable docker image on Application Server 2.

b. Create a container named official using the image you pulled.

c. Map host port 8084 to container port 80. Please keep the container in running state.

Solution:

1. SSH to the app server requested - it may be a different app server for you.

   ```
   ssh steve@stapp02
   ```

2. Become root to save typing `sudo` on every command

   ```
   sudo su
   ```

3. Pull the image

   ```
   docker pull nginx:stable
   ```

4. Create the container

   ```
   docker run -it -d --name official -p 8084:80 nginx:alpine
   ```

5. Check the nginx
   ```
   docker exec -it official /bin/sh
   curl http://localhost
   ```
