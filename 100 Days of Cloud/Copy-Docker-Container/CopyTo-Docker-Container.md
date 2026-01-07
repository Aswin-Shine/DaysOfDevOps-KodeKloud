The Nautilus DevOps team possesses confidential data on App Server 2 in the Stratos Datacenter. A container named ubuntu_latest is running on the same server.

Copy an encrypted file /tmp/nautilus.txt.gpg from the docker host to the ubuntu_latest container located at /usr/src/. Ensure the file is not modified during this operation.

Solution :

```
ssh steve@stapp02
docker ps
sudo docker cp /tmp/nautilus.txt.gpg ubuntu_latest:/usr/src/
sudo docker exec -it ubuntu_latest  ls /usr/src/

```
