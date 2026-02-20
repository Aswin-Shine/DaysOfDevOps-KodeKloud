Some new requirements have come up to install and configure some packages on the Nautilus infrastructure under Stratos Datacenter. The Nautilus DevOps team installed and configured a new Jenkins server so they wanted to create a Jenkins job to automate this task. Find below more details and complete the task accordingly:

1. Access the Jenkins UI by clicking on the Jenkins button in the top bar. Log in using the credentials: username admin and password Adm!n321.

2. Create a new Jenkins job named install-packages and configure it with the following specifications:
Add a string parameter named PACKAGE.

Configure the job to install a package specified in the $PACKAGE parameter on the storage server within the Stratos Datacenter.

Solution :

1. Login into Jenkins Server

2. Create a new project and name it as install-packages (Freestyle Project)

3. Choose option "This Project is Parameterized" & add Parameter name PACKAGE (String Parameter)

4. In Build Steps choose excute shell & and this shell command

```
sshpass -p "Bl@kW" ssh -o StrictHostKeyChecking=no natasha@ststor01 "echo 'Bl@kW' | sudo -S yum install -y $PACKAGE"
```

5. Build with parameters
