There is a requirement to create a Jenkins job to automate the database backup. Below you can find more details to accomplish this task:

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.

Create a Jenkins job named database-backup.

Configure it to take a database dump of the kodekloud_db01 database present on the Database server in Stratos Datacenter, the database user is kodekloud_roy and password is asdfgdsd.

The dump should be named in db\_$(date +%F).sql format, where date +%F is the current date.

Copy the db\_$(date +%F).sql dump to the Backup Server under location /home/clint/db_backups.

Further, schedule this job to run periodically at _/10 _ \* \* \* (please use this exact schedule format).

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
```

3. Create a jenkins job named "database-backup"

4. In triggers section choose Build Periodically and add this

```
*/10 * * * * [This is cron job for every 10th minute]
```

5. Choose execute shell and this script

```
ssh peter@stdb01 "mysqldump -u kodekloud_roy -pasdfgdsd kodekloud_db01" > db_$(date +%F).sql && scp db_$(date +%F).sql clint@stbkp01:/home/clint/db_backups
```

6. To check log are copied run these commands in Jenkins Server Terminal

```
ssh clint@stbkp01
ls -l /db_backups/
```
