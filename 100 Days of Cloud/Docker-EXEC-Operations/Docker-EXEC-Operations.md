One of the Nautilus DevOps team members was working to configure services on a kkloud container that is running on App Server 2 in Stratos Datacenter. Due to some personal work he is on PTO for the rest of the week, but we need to finish his pending work ASAP. Please complete the remaining work as per details given below:

a. Install apache2 in kkloud container using apt that is running on App Server 2 in Stratos Datacenter.

b. Configure Apache to listen on port 6000 instead of default http port. Do not bind it to listen on specific IP or hostname only, i.e it should listen on localhost, 127.0.0.1, container ip, etc.

c. Make sure Apache service is up and running inside the container. Keep the container in running state at the end.

Solution :

1. SSH to the app server requested - it may be a different app server for you.

   ```
   ssh steve@stapp02
   ```

2. Become root to save typing `sudo` on every command

   ```
   sudo su
   ```

3. Check Running Containers

```
docker ps
```

4. Get inside the kkloud container

```
docker exec -it kkloud /bin/sh
```

5. Install vim (Optional)

```
apt install vim -y
```

6. Update and install `apache2`

   ```
   apt update
   apt install apache2 -y
   ```

7. Configure apache

   1. Edit `vim /etc/apache2/ports.conf`.
   2. Change the `Listen` line to `6000` instead of `80`.
   3. Edit `vim /etc/apache2/sites-enabled/000-default.conf`.
   4. Change the `<VirtualHost` line to `<VirtualHost *:6000>`
   5. Save and exit.

8. Start the service and check status

   ```
   service apache2 restart
   service apache2 status
   ```

9. Check if apache is working
   ```
   curl http://localhost:6000
   ```
