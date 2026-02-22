The devops team of xFusionCorp Industries is working on to setup centralised logging management system to maintain and analyse server logs easily. Since it will take some time to implement, they wanted to gather some server logs on a regular basis. At least one of the app servers is having issues with the Apache server. The team needs Apache logs so that they can identify and troubleshoot the issues easily if they arise. So they decided to create a Jenkins job to collect logs from the server. Please create/configure a Jenkins job as per details mentioned below:

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321

1. Create a Jenkins jobs named copy-logs.

2. Configure it to periodically build every 4 minutes to copy the Apache logs (both access_log and error_logs) from App Server 3 (from default logs location) to location /usr/src/dba on Storage Server.

Solution :

1. Login into jenkins server

```
ssh jenkins@jenkins
```

2. Create ssh key and send to the servers.

```
ssh-keygen -t rsa
ls -l ~/.ssh/

ssh-copy-id banner@stapp03
ssh-copy-id natasha@ststor01
```

3. Create a jenkins job named "copy-logs"

4. In triggers section choose Poll SCM and add this

```
*/4 * * * * [This is cron job for every 4th minute]
```

5. Choose execute shell and this script

```
scp banner@stapp03:/var/log/httpd/access_log .
scp banner@stapp03:/var/log/httpd/error_log .

scp access_log error_log natasha@ststor01:/usr/src/dba
```

6. To check log are copied run these commands in Jenkins Server Terminal

```
ssh natasha@ststor01
ls -l /usr/src/dba
```
