The DevOps team at xFusionCorp Industries is initiating the setup of CI/CD pipelines and has decided to utilize Jenkins as their server. Execute the task according to the provided requirements:


1. Install Jenkins on the jenkins server using the yum utility only, and start its service.

If you face a timeout issue while starting the Jenkins service, refer to this.
2. Jenkin's admin user name should be theadmin, password should be Adm!n321, full name should be Javed and email should be javed@jenkins.stratos.xfusioncorp.com.


Note:

1. To access the jenkins server, connect from the jump host using the root user with the password S3curePass.

2. After Jenkins server installation, click the Jenkins button on the top bar to access the Jenkins UI and follow on-screen instructions to create an admin user.

Solution : 

1. SSH into root using the password 
```
ssh root@jenkins
```

2. Update the server
```
sudo yum update -y
```

3. Commands to install jenkins 
```
sudo yum install epel-release java-17-openjdk wget -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo --no-check-certificate
sudo rpm --import http://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

sudo yum update -y
sudo yum install jenkins -y
```
4. Check the Jenkins have started or not 
```
sudo systemctl status jenkins
sudo systemctl start jenkins && systemctl status jenkins 

```
5. Get the inital admin password 
```
cat /var/lib/jenkins/secrets/initialAdminPassword 
```