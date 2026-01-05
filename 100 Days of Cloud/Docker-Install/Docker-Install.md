The Nautilus DevOps team aims to containerize various applications following a recent meeting with the application development team. They intend to conduct testing with the following steps:  
 Install docker-ce and docker compose packages on App Server 1.  
 Initiate the docker service.  
Solution:

```
ssh tony@stapp01
sudo su
sudo dnf update -y
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker --version
docker compose version
sudo systemctl enable --now docker
sudo systemctl status docker
```
