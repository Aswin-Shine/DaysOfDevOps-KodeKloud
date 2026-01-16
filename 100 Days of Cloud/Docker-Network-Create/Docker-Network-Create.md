The Nautilus DevOps team needs to set up several docker environments for different applications. One of the team members has been assigned a ticket where he has been asked to create some docker networks to be used later. Complete the task based on the following ticket description:

a. Create a docker network named as media on App Server 2 in Stratos DC.

b. Configure it to use macvlan drivers.

c. Set it to use subnet 172.168.0.0/24 and iprange 172.168.0.0/24.

Solution:

1. SSH to the app server requested - it may be a different app server for you.

   ```
   ssh steve@stapp02
   ```

2. Become root to save typing `sudo` on every command

   ```
   sudo su
   ```

3. Creata network

   ```
   docker network create -d macvlan --subnet 172.168.0.0/24  --ip-range 172.168.0.0/24 media
   ```

4. Inspect the network

   ```
   docker network inspect media
   ```
