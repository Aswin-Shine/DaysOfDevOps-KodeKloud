The Nautilus DevOps team has installed and configured new Jenkins server in Stratos DC which they will use for CI/CD and for some automation tasks. There is a requirement to add all app servers as slave nodes in Jenkins so that they can perform tasks on these servers using Jenkins. Find below more details and accomplish the task accordingly.

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.

1. Add all app servers as SSH build agent/slave nodes in Jenkins. Slave node name for app server 1, app server 2 and app server 3 must be App_server_1, App_server_2, App_server_3 respectively.

2. Add labels as below:

App_server_1 : stapp01

App_server_2 : stapp02

App_server_3 : stapp03

3. Remote root directory for App_server_1 must be /home/tony/jenkins, for App_server_2 must be /home/steve/jenkins and for App_server_3 must be /home/banner/jenkins.

4. Make sure slave nodes are online and working properly.

Solution :

1. Login into jenkins server

```
ssh jenkins@jenkins
```

2. Create ssh key and send to the servers.

```
ssh-keygen -t rsa
ls -l ~/.ssh/

ssh-copy-id peter@stdb01
ssh-copy-id clint@stbkp01

3. Create a jenkins job named "install-java"

4. Choose execute shell and this script

```

ssh tony@stapp01 "echo 'Ir0nM@n' | sudo -S yum install java-21-openjdk -y"
ssh steve@stapp02 "echo 'Am3ric@' | sudo -S yum install java-21-openjdk -y"
ssh banner@stapp03 "echo 'BigGr33n' | sudo -S yum install java-21-openjdk -y"

```
5. Build now

6. Manage Jenkins and Install SSH plugins from plugins section

7. Manage Jenikins go to Credentials ------> Global Credentials --------> Create Credential ------> Add Server Credentials

8. Manage Jenkins then go to Nodes section

9. Create node with name App_server_1 and add these specifications
      -- In Labels section -------> App_server_1
      -- In Usage section -------> Only build jobs with label expression matching this node.
      -- In Launch Method section -------> Launch Agents via SSH ---------> Host [stapp01], Credentials [tony], Host key Verification Strategy [Manually Trusted Key Strategy]
      -- In Remote root directory section -----> /home/tony/jenkins

Repeat steps 7 to 9 for every App Server.
```
