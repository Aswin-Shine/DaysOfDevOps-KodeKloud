The Nautilus development team had a meeting with the DevOps team where they discussed automating the deployment of one of their apps using Jenkins (the one in Stratos Datacenter).
They want to auto deploy the new changes in case any developer pushes to the repository. As per the requirements mentioned below configure the required Jenkins job.
Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and Adm!n321 password.
Similarly, you can access the Gitea UI using Gitea button, username and password for Git is sarah and Sarah_pass123 respectively.
Under user sarah you will find a repository named web that is already cloned on the Storage server under sarah's home. sarah is a developer who is working on this repository.

Install httpd (whatever version is available in the yum repo by default) and configure it to serve on port 8080 on All app servers. You can make it part of your Jenkins job or you can do this step manually on all app servers.
Create a Jenkins job named nautilus-app-deployment and configure it in a way so that if anyone pushes any new change to the origin repository in master branch,
the job should auto build and deploy the latest code on the Storage server under /var/www/html directory. Since /var/www/html on Storage server is shared among all apps.
Before deployment, ensure that the ownership of the /var/www/html directory is set to user sarah, so that Jenkins can successfully deploy files to that directory.
SSH into Storage Server using sarah user credentials mentioned above. Under sarah user's home you will find a cloned Git repository named web.
Under this repository there is an index.html file, update its content to Welcome to the xFusionCorp Industries, then push the changes to the origin into master branch.
This push must trigger your Jenkins job and the latest changes must be deployed on the servers, also make sure it deploys the entire repository content not only index.html file.

Solution :

1 -- Login into Jenkins UI

2 -- Go to Manage Jenkins -----> Install plugins (git, ssh, pipeline).

3 -- Manage Jenikins go to Credentials ------> Global Credentials --------> Create Credential ------> Add Server Credentials. [tony, steve, banner, sarah]

4 -- Create pipeline job for installing httpd on to the servers.

```
node {
    stage('Initialize') {
        echo "Starting Deployment Process..."
    }

    stage('Deploy to App Servers') {
        parallel(
            "stapp01": {
                stage('stapp01') {
                    withCredentials([usernamePassword(credentialsId: 'tony', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh """
                            sshpass -p '${PASS}' ssh -o StrictHostKeyChecking=no -tt ${USER}@stapp01 \
                            "echo '${PASS}' | sudo -S yum install -y httpd && \
                             sudo sed -i 's/^Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf && \
                             sudo systemctl restart httpd && \
                             echo 'SUCCESS: httpd is live on 8080 at stapp01'"
                        """
                    }
                }
            },
            "stapp02": {
                stage('stapp02') {
                    withCredentials([usernamePassword(credentialsId: 'steve', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh """
                            sshpass -p '${PASS}' ssh -o StrictHostKeyChecking=no -tt ${USER}@stapp02 \
                            "echo '${PASS}' | sudo -S yum install -y httpd && \
                             sudo sed -i 's/^Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf && \
                             sudo systemctl restart httpd && \
                             echo 'SUCCESS: httpd is live on 8080 at stapp02'"
                        """
                    }
                }
            },
            "stapp03": {
                stage('stapp03') {
                    withCredentials([usernamePassword(credentialsId: 'banner', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh """
                            sshpass -p '${PASS}' ssh -o StrictHostKeyChecking=no -tt ${USER}@stapp03 \
                            "echo '${PASS}' | sudo -S yum install -y httpd && \
                             sudo sed -i 's/^Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf && \
                             sudo systemctl restart httpd && \
                             echo 'SUCCESS: httpd is live on 8080 at stapp03'"
                        """
                    }
                }
            }
        )
    }

    stage('Cleanup') {
        echo "All deployments finished successfully!"
    }
}
```

5 -- Build this pipeline

6 -- Login into database server to check on the sarah user have permission on this foldder (/var/www/html)

```
ssh natasha@ststor01
cd /var/www/html
ls -l
```

If permission is not there, give permissions

```
sudo chown -R sarah:sarah /var/www/html
```

7 -- Create a jenkins job named nautilus-app-deployment

      -- Source Code Management -----> Git -----> Git url : http://git.stratos.xfusioncorp.com/sarah/web.git -----> Credentials (Sarah)

      -- Triggers ------> POLL SCM -----> * * * * * (This means it will look for changes every minute.)

      -- Environment ------> Use secret text or file -------> Bindings -------> Secret Text

      -- Excute Shell

```
sshpass -p "$sarah_pass" scp -0 StrictHostKeyChecking=no -r * sarah@ststor01:/var/www/html
```

8 -- Login into storage server using Sarah user and git push new changes to trigger the build.

```
ssh sarah@ststor01
cd /home/sarah/web
ls -l
cat index.html

vi index.html ---------------> Welcome to the FusionCorp Industries.
cat index.html

git status
git add index.html
git commit -m "Updated the index.html"
git push origin master

```

9. Check build triggered successfully.
