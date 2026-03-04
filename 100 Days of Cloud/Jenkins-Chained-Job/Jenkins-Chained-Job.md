The DevOps team was looking for a solution where they want to restart Apache service on all app servers if the deployment goes fine on these servers in Stratos Datacenter. After having a discussion, they came up with a solution to use Jenkins chained builds so that they can use a downstream job for services which should only be triggered by the deployment job. So as per the requirements mentioned below configure the required Jenkins jobs.

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and Adm!n321 password.

Similarly you can access Gitea UI on port 8090 and username and password for Git is sarah and Sarah_pass123 respectively. Under user sarah you will find a repository named web.

Apache is already installed and configured on all app server so no changes are needed there. The doc root /var/www/html on all these app servers is shared among the Storage server under /var/www/html directory.

1. Create a Jenkins job named nautilus-app-deployment and configure it to pull change from the master branch of web repository on Storage server under /var/www/html directory, which is already a local git repository tracking the origin web repository. Since /var/www/html on Storage server is a shared volume so changes should auto reflect on all apps.

2. Create another Jenkins job named manage-services and make it a downstream job for nautilus-app-deployment job. Things to take care about this job are:

a. This job should restart httpd service on all app servers.

b. Trigger this job only if the upstream job i.e nautilus-app-deployment is stable.

Solution :

1 -- Login into Jenkins UI

2 -- Create a job named "nautilus-app-deployment"
-- Write these commands in execute shell

```
sshpass -p "Bl@kW" ssh -o StrictHostKeyChecking=no natasha@ststor01 "cd /var/www/html && git pull origin master"
```

3 -- Create the other job named
-- Write these commands in execute shell

```
sshpass -p "Ir0nM@n" ssh -o StrictHostKeyChecking=no tony@stapp01 "echo 'Ir0nM@n'| sudo -S systemctl restart httpd"

sshpass -p "Am3ric@" ssh -o StrictHostKeyChecking=no steve@stapp02 "echo 'Am3ric@' | sudo -S systemctl restart httpd"

sshpass -p "BigGr33n" ssh -o StrictHostKeyChecking=no banner@stapp03 "echo 'BigGr33n' | sudo -S systemctl restart httpd"
```

4 -- Go to the configure of First Job
-- Post-Build Actions -------> Trigger only build is stable ------> manage-services, (Second job name)

5 -- Build the first job now (nautilus-app-deployment)
