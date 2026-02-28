The development team of xFusionCorp Industries is working on to develop a new static website and they are planning to deploy the same on Nautilus App Servers using Jenkins pipeline. They have shared their requirements with the DevOps team and accordingly we need to create a Jenkins pipeline job. Please find below more details about the task:

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.

Similarly, click on the Gitea button on the top bar to access the Gitea UI. Login using username sarah and password Sarah_pass123. There under user sarah you will find a repository named web_app that is already cloned on Storage server under /var/www/html. sarah is a developer who is working on this repository.

Add a slave node named Storage Server. It should be labeled as ststor01 and its remote root directory should be /var/www/html.

We have already cloned repository on Storage Server under /var/www/html.

Apache is already installed on all app Servers its running on port 8080.

Create a Jenkins pipeline job named datacenter-webapp-job (it must not be a Multibranch pipeline) and configure it to:

Add a string parameter named BRANCH.

It should conditionally deploy the code from web_app repository under /var/www/html on Storage Server, as this location is already mounted to the document root /var/www/html of app servers. The pipeline should have a single stage named Deploy ( which is case sensitive ) to accomplish the deployment.

The pipeline should be conditional, if the value master is passed to the BRANCH parameter then it must deploy the master branch, on the other hand if the value feature is passed to the BRANCH parameter then it must deploy the feature branch.

LB server is already configured. You should be able to see the latest changes you made by clicking on the App button. Please make sure the required content is loading on the main URL https://<LBR-URL> i.e there should not be a sub-directory like https://<LBR-URL>/web_app etc.

Solution :

1. Login into Storage server and install java.

```
ssh natasha@ststor01
sudo su
yum install java-openjdk-21 -y
cd /var/www/html
ls -l
chown -R natasha /var/www/html
```

2. Open Jenkins UI and install plugins (git, ssh, pipeline)

3. Manage Jenikins go to Credentials ------> Global Credentials --------> Create Credential ------> Add Server Credentials

4. Manage Jenkins then go to Nodes section

5. Create node with name Storage serve and add these specifications
   -- In Labels section -------> ststor01
   -- In Usage section -------> Only build jobs with label expression matching this node.
   -- In Launch Method section -------> Launch Agents via SSH ---------> Host [ststor01], Credentials [natasha], Host key Verification Strategy [Manually Trusted Key Strategy]
   -- In Remote root directory section -----> /var/www/html

6. Create a pipeline job named datacenter-webapp-job

7. Add pipeline job script

```
pipeline {
    agent { label 'ststor01' }

    parameters {
        string(name: 'BRANCH', defaultValue: 'master', description: 'Branch to deploy (master or feature)')
    }

    stages {
        stage('Deploy') {
            when {
                expression { params.BRANCH == 'master' || params.BRANCH == 'feature' }
            }
            steps {
                script {
                    git branch: params.BRANCH,
                        url: 'http://git.stratos.xfusioncorp.com/sarah/web_app.git'
                    sh "cp -r ./* /var/www/html/"
                }
            }
        }
    }
}

```

8. Build Now
