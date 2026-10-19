# Days of DevOps : KodeKloud

My hands-on solutions to the daily DevOps tasks from **[KodeKloud Engineer](https://engineer.kodekloud.com/)**. Each folder is one task: the problem statement, the commands/config I used to solve it, and screenshots of the result.

Most tasks take place in KodeKloud's fictional **Stratos Datacenter** (Nautilus / xFusionCorp projects): a jump host, three app servers, a storage server, a database server and a load balancer. Terraform tasks run against AWS APIs in KodeKloud's lab environment.

![Tasks](https://img.shields.io/badge/tasks-126-blue) ![Days](https://img.shields.io/badge/days-116-green) ![Linux](https://img.shields.io/badge/-Linux-FCC624?logo=linux&logoColor=black) ![Git](https://img.shields.io/badge/-Git-F05032?logo=git&logoColor=white) ![Docker](https://img.shields.io/badge/-Docker-2496ED?logo=docker&logoColor=white) ![Kubernetes](https://img.shields.io/badge/-Kubernetes-326CE5?logo=kubernetes&logoColor=white) ![Jenkins](https://img.shields.io/badge/-Jenkins-D24939?logo=jenkins&logoColor=white) ![Ansible](https://img.shields.io/badge/-Ansible-EE0000?logo=ansible&logoColor=white) ![Terraform](https://img.shields.io/badge/-Terraform-7B42BC?logo=terraform&logoColor=white) ![AWS](https://img.shields.io/badge/-AWS-232F3E?logo=amazonwebservices&logoColor=white)

## 📂 Repository structure

```text
.
├── 100 Days of Cloud/          # One folder per task
│   └── <Task-Name>/
│       ├── <Task-Name>.md      # Problem statement + step-by-step solution
│       ├── Screenshot/         # Proof of completion
│       └── *.sh                # Helper script (a few tasks only)
└── 50 Days of Amazon CLI/      # Upcoming series (placeholder for now)
```

## 📊 Progress at a glance

| Topic | Days | Tasks |
|---|---|---|
| 🐧 Linux, Web Servers & Databases | 1 – 8 | 12 |
| 🌿 Git | 9 – 15 | 13 |
| 🐳 Docker | 16 – 28 | 13 |
| ☸️ Kubernetes | 29 – 48 | 20 |
| 🛠️ Jenkins | 49 – 60 | 12 |
| 📜 Ansible | 61 – 84 | 19 |
| 🏗️ Terraform (AWS) | 76 – 116 | 37 |
| **Total** | **1 – 116** | **126** |

> Note: day numbers follow the commit history. Some days cover more than one task, Ansible and Terraform days overlap (Days 76–84), and there is no Day 45 entry.

## 🗂️ Tasks

### 🐧 Linux, Web Servers & Databases

Server administration on CentOS/RHEL-style hosts: services, firewalls, web servers, databases.

| Day | Task | Solution |
|:---:|---|---|
| 1 | Troubleshoot a MariaDB service that is down | [MariaDB-Troubleshooting](100%20Days%20of%20Cloud/MariaDB-Troubleshooting/MariaDB-Commands.md) |
| 1 | Install Tomcat and deploy a Java app | [Tomcat-Installtion](100%20Days%20of%20Cloud/Tomcat-Installtion/TomCat-Install.md) |
| 1 | Fix Apache unreachable on port 8088 (port conflict + iptables) | [Linux-Networking](100%20Days%20of%20Cloud/Linux-Networking/Networking-Services.md) |
| 2 | Bash script to automate website backups | [Linux-Bash](100%20Days%20of%20Cloud/Linux-Bash/Linux-Bash.md) |
| 3 | Install iptables and restrict port access | [IP-Tables](100%20Days%20of%20Cloud/IP-Tables/IP-Tables%20Installtion%20and%20Config.md) |
| 4 | Troubleshoot a failing Apache process | [Linux-Process-Troubleshooting](100%20Days%20of%20Cloud/Linux-Process-Troubleshooting/Process%20Troubleshooting.md) |
| 5 | Configure Nginx with a self-signed SSL certificate | [SSL-Nginx](100%20Days%20of%20Cloud/SSL-Nginx/SSL-Nginx.md) |
| 6 | Configure Nginx as a load balancer | [Nginx-LBR](100%20Days%20of%20Cloud/Nginx-LBR/Nginx-LBR.md) |
| 7 | Create a PostgreSQL database and user | [Configure-Postgresql](100%20Days%20of%20Cloud/Configure-Postgresql/Configure-Postgresql.md) |
| 7 | Set up a LAMP stack for WordPress | [LAMP-Stack](100%20Days%20of%20Cloud/LAMP-Stack/LAMP-Stack.md) |
| 8 | Host two static websites on Apache | [Configure-WebApps](100%20Days%20of%20Cloud/Configure-WebApps/Configure-WebApps.md) |
| 8 | Nginx + PHP-FPM over a Unix socket | [Nginx-PHP-FRM-using-UnixSock](100%20Days%20of%20Cloud/Nginx-PHP-FRM-using-UnixSock/Nginx-Php-UnixSock.md) |

### 🌿 Git

Repository administration on the storage server.

| Day | Task | Solution |
|:---:|---|---|
| 9 | Create a bare Git repository | [Bare-Git-Repo](100%20Days%20of%20Cloud/Bare-Git-Repo/Bare-Git-Repo.md) |
| 10 | Clone a repository | [Git-Clone-Repo](100%20Days%20of%20Cloud/Git-Clone-Repo/Git-Clone-Repo.md) |
| 10 | Create a branch | [Git-Branch](100%20Days%20of%20Cloud/Git-Branch/Git-Branch-Creation.md) |
| 10 | Create a branch, commit and merge to master | [Git-Merge](100%20Days%20of%20Cloud/Git-Merge/Git-Merge.md) |
| 11 | Add a new remote and push | [Git-Remote-Add](100%20Days%20of%20Cloud/Git-Remote-Add/Git-Remote-Add.md) |
| 11 | Revert the latest commit | [Git-Revert](100%20Days%20of%20Cloud/Git-Revert/Git-Revert.md) |
| 11 | Cherry-pick a commit across branches | [Git-Cherry](100%20Days%20of%20Cloud/Git-Cherry/Git-Cherry.md) |
| 12 | Branch protection workflow with pull requests (Gitea) | [Git-Pull-Requests](100%20Days%20of%20Cloud/Git-Pull-Requests/Git-Pull-Requests.md) |
| 13 | Hard reset to clean up history | [Git-Hard-Reset](100%20Days%20of%20Cloud/Git-Hard-Reset/Git-Hard-Reset.md) |
| 14 | Restore stashed changes | [Git-Stash](100%20Days%20of%20Cloud/Git-Stash/Git-Stash.md) |
| 14 | Rebase a feature branch onto master | [Git-Rebase](100%20Days%20of%20Cloud/Git-Rebase/Git-Rebase.md) |
| 14 | Resolve a merge conflict | [Git-Merge-Conflicts](100%20Days%20of%20Cloud/Git-Merge-Conflicts/Git-Merge-Conflicts.md) |
| 15 | Server-side post-update hook to create release tags | [Git-Hook](100%20Days%20of%20Cloud/Git-Hook/Git-Hook.md) |

### 🐳 Docker

Installing Docker and building, running and debugging containers.

| Day | Task | Solution |
|:---:|---|---|
| 16 | Install Docker CE and Docker Compose | [Docker-Install](100%20Days%20of%20Cloud/Docker-Install/Docker-Install.md) |
| 17 | Run an Nginx container | [Docker-Install-Nginx](100%20Days%20of%20Cloud/Docker-Install-Nginx/Docker-Install-Nginx.md) |
| 18 | Copy a file into a running container | [Copy-Docker-Container](100%20Days%20of%20Cloud/Copy-Docker-Container/CopyTo-Docker-Container.md) |
| 19 | Pull and re-tag an image | [Docker-Pull-Image](100%20Days%20of%20Cloud/Docker-Pull-Image/Docker-Pull-Image.md) |
| 20 | Create an image from a container | [Docker-Create-Image-from-Cont](100%20Days%20of%20Cloud/Docker-Create-Image-from-Cont/Create-Image-from-Container.md) |
| 21 | Configure Apache inside a running container | [Docker-EXEC-Operations](100%20Days%20of%20Cloud/Docker-EXEC-Operations/Docker-EXEC-Operations.md) |
| 22 | Write a Dockerfile for a custom Apache image | [Docker-File-Create](100%20Days%20of%20Cloud/Docker-File-Create/Docker-File-Create.md) |
| 23 | Create a macvlan Docker network | [Docker-Network-Create](100%20Days%20of%20Cloud/Docker-Network-Create/Docker-Network-Create.md) |
| 24 | Run a container with port mapping | [Docker-Port-Mappings](100%20Days%20of%20Cloud/Docker-Port-Mappings/Docker-Port-Mapping.md) |
| 25 | Host a static site with Docker Compose | [Docker-Compose-Create](100%20Days%20of%20Cloud/Docker-Compose-Create/Docker-Compose-Create.md) |
| 26 | Fix a broken Dockerfile | [Dockerfile-Resolve](100%20Days%20of%20Cloud/Dockerfile-Resolve/Dockerfile-Resolve.md) |
| 27 | Multi-container app deployment with Compose | [Docker-App-Deployment](100%20Days%20of%20Cloud/Docker-App-Deployment/Docker-App-Deployment.md) |
| 28 | Dockerize and deploy a Python app | [Docker-Python-App](100%20Days%20of%20Cloud/Docker-Python-App/Docker-Python-App.md) |

### ☸️ Kubernetes

Pods, Deployments, Services, volumes, secrets and troubleshooting with `kubectl`.

| Day | Task | Solution |
|:---:|---|---|
| 29 | Create a Pod | [K8S-Pod-Creation](100%20Days%20of%20Cloud/K8S-Pod-Creation/K8S-Pod-Creation.md) |
| 29 | Create a Deployment | [K8S-App-Deployment](100%20Days%20of%20Cloud/K8S-App-Deployment/K8S-App-Deployment.md) |
| 30 | Rolling update to a new image | [K8S-Rolling-Update](100%20Days%20of%20Cloud/K8S-Rolling-Update/K8S-Rolling-Update.md) |
| 31 | Set resource requests and limits | [K8S-Set-Resource-Limit](100%20Days%20of%20Cloud/K8S-Set-Resource-Limit/K8S-Set-Resource-Limit.md) |
| 32 | Roll back a Deployment | [K8S-Revert-Deployment](100%20Days%20of%20Cloud/K8S-Revert-Deployment/K8S-Revert-Deployment.md) |
| 33 | Fix an Nginx + PHP-FPM volume mount issue | [K8S-Resolve-VolumeMounts](100%20Days%20of%20Cloud/K8S-Resolve-VolumeMounts/K8S-Resolve-VolumeMount.md) |
| 34 | Share a volume between containers | [K8S-Shared-Volume](100%20Days%20of%20Cloud/K8S-Shared-Volume/K8S-Shared-Volume.md) |
| 35 | Log-shipping sidecar container | [K8S-Sidecar-Container](100%20Days%20of%20Cloud/K8S-Sidecar-Container/K8S-Sidecar-Container.md) |
| 36 | Highly available Nginx Deployment + NodePort Service | [K8S-Nginx-Deployment](100%20Days%20of%20Cloud/K8S-Nginx-Deployment/K8S-Nginx-Deployment.md) |
| 37 | Pass and print environment variables | [K8S-Print-Env-Variables](100%20Days%20of%20Cloud/K8S-Print-Env-Variables/K8S-Print-Env-Variables.md) |
| 38 | Deploy Grafana | [K8S-Deploy-Grafana](100%20Days%20of%20Cloud/K8S-Deploy-Grafana/K8S-Deploy-Grafana.md) |
| 39 | Troubleshoot a broken Redis Deployment | [K8S-Deployment-Troubleshoot](100%20Days%20of%20Cloud/K8S-Deployment-Troubleshoot/K8S-Deployment-Troubleshoot.md) |
| 40 | PersistentVolume + PersistentVolumeClaim | [K8S-Persistent-Volume](100%20Days%20of%20Cloud/K8S-Persistent-Volume/K8S-Persistent-Volume.md) |
| 41 | Init containers | [K8S-Init-Containers](100%20Days%20of%20Cloud/K8S-Init-Containers/K8S-Init-Containers.md) |
| 42 | Manage Secrets | [K8S-Manage-Secrets](100%20Days%20of%20Cloud/K8S-Manage-Secrets/K8S-Manage-Secrets.md) |
| 43 | Deploy the Iron Gallery app | [K8S-Deploy-Iron-Gallery](100%20Days%20of%20Cloud/K8S-Deploy-Iron-Gallery/K8S-Deploy-Iron-Gallery.md) |
| 44 | Fix a broken Python app Deployment | [K8S-Fix-Python-App](100%20Days%20of%20Cloud/K8S-Fix-Python-App/K8S-Fix-Python-App.md) |
| 46 | Deploy Redis with a ConfigMap | [K8S-Deploy-Redis](100%20Days%20of%20Cloud/K8S-Deploy-Redis/K8S-Deploy-Redis.md) |
| 47 | Deploy MySQL with PV, PVC and Secrets | [K8S-Deploy-MySql](100%20Days%20of%20Cloud/K8S-Deploy-MySql/K8S-Deploy-MySQL.md) |
| 48 | Deploy the multi-tier Guestbook app | [K8S-Deploy-Guest-Book](100%20Days%20of%20Cloud/K8S-Deploy-Guest-Book/K8S-Deploy-Guest-Book.md) |

### 🛠️ Jenkins

Jenkins setup, freestyle jobs and declarative pipelines.

| Day | Task | Solution |
|:---:|---|---|
| 49 | Install and set up Jenkins | [Jenkins-Setup](100%20Days%20of%20Cloud/Jenkins-Setup/Jenkins-Setup.md) |
| 50 | Parameterized job that installs a package on the storage server | [Jenkins-Job-Package-Installtion](100%20Days%20of%20Cloud/Jenkins-Job-Package-Installtion/Jenkins-Job-Package-Installtion.md) |
| 51 | Parameterized build | [Jenkins-Parameterized-Job-Config](100%20Days%20of%20Cloud/Jenkins-Parameterized-Job-Config/Jenkins-Parameterized-Job-Config.md) |
| 52 | Scheduled job to collect server logs | [Jenkins-Scheduled-Jobs](100%20Days%20of%20Cloud/Jenkins-Scheduled-Jobs/Jenkins-Scheduled-Jobs.md) |
| 53 | Job to automate database backups | [Jenkins-Database-Backup](100%20Days%20of%20Cloud/Jenkins-Database-Backup/Jenkins-Database-Backup.md) |
| 54 | Add app servers as agent (slave) nodes | [Jenkins-Slave-Nodes](100%20Days%20of%20Cloud/Jenkins-Slave-Nodes/Jenkins-Slave-Nodes.md) |
| 55 | Project-based matrix authorization | [Jenkins-Project-Security](100%20Days%20of%20Cloud/Jenkins-Project-Security/Jenkins-Project-Security.md) |
| 56 | Pipeline to deploy a static website | [Jenkins-Deploy-Pipeline](100%20Days%20of%20Cloud/Jenkins-Deploy-Pipeline/Jenkins-Deploy-Pipeline.md) |
| 57 | Pipeline with conditional/parameterized deploys | [Jenkins-Conditional-Pipeline](100%20Days%20of%20Cloud/Jenkins-Conditional-Pipeline/Jenkins-Conditional-Pipeline.md) |
| 58 | Deployment job triggered from Git | [Jenkins-Deployment-Job](100%20Days%20of%20Cloud/Jenkins-Deployment-Job/Jenkins-Deployment-Job.md) |
| 59 | Chained (downstream) jobs | [Jenkins-Chained-Job](100%20Days%20of%20Cloud/Jenkins-Chained-Job/Jenkins-Chained-Job.md) |
| 60 | Multi-stage pipeline | [Jenkins-Multistage-Pipeline](100%20Days%20of%20Cloud/Jenkins-Multistage-Pipeline/Jenkins-Multistage-Pipeline.md) |

### 📜 Ansible

Inventories, playbooks and core modules run from the jump host.

| Day | Task | Solution |
|:---:|---|---|
| 61 | Create an inventory file | [Ansible-Create-Inventory-Servers](100%20Days%20of%20Cloud/Ansible-Create-Inventory-Servers/Ansible-Create-Inventory-Servers.md) |
| 62 | Troubleshoot and complete a playbook | [Ansible-Troubleshoot&Create-Playbook](100%20Days%20of%20Cloud/Ansible-Troubleshoot%26Create-Playbook/Ansible-Troubleshoot%26Create-Playbook.md) |
| 63 | Copy data with the `copy` module | [Ansible-Copy-Data-To-Servers](100%20Days%20of%20Cloud/Ansible-Copy-Data-To-Servers/Ansible-Copy-data-to-Servers.md) |
| 64 | Create files with the `file` module | [Ansible-Create-file-on-Servers](100%20Days%20of%20Cloud/Ansible-Create-file-on-Servers/Ansible-Create-file-on-Servers.md) |
| 65 | Test connectivity with the `ping` module | [Ansible-Ping-Module](100%20Days%20of%20Cloud/Ansible-Ping-Module/Ansible-Ping-Module.md) |
| 66 | Install packages | [Ansible-Install-Packages](100%20Days%20of%20Cloud/Ansible-Install-Packages/Ansible-Install-Packages.md) |
| 67 | `blockinfile` module | [Ansible-Blockinfile-Module](100%20Days%20of%20Cloud/Ansible-Blockinfile-Module/Ansible-Blockinfile-Module.md) |
| 68 | Install packages and manage services | [Ansible-Manage-Services](100%20Days%20of%20Cloud/Ansible-Manage-Services/Ansible-Manage-Services.md) |
| 69 | Set file ACLs with the `acl` module | [Ansible-Manage-ACL-Services](100%20Days%20of%20Cloud/Ansible-Manage-ACL-Services/Ansible-Manage-ACL-Services.md) |
| 70 | `lineinfile` module | [Ansible-Lineinfile-Module](100%20Days%20of%20Cloud/Ansible-Lineinfile-Module/Ansible-Lineinfile-Module.md) |
| 71 | Jinja2 templates inside a role | [Ansible-Managing-Jinja2](100%20Days%20of%20Cloud/Ansible-Managing-Jinja2/Ansible-Managing-Jinja.md) |
| 72 | `when` conditionals | [Ansible-Conditionals](100%20Days%20of%20Cloud/Ansible-Conditionals/Ansible-Conditionals.md) |
| 73 | `archive` module | [Ansible-Archive-Module](100%20Days%20of%20Cloud/Ansible-Archive-Module/Ansible-Archive-Module.md) |
| 74 | `unarchive` module | [Ansible-Unarchive-Module](100%20Days%20of%20Cloud/Ansible-Unarchive-Module/Ansible-Unarchive-Module.md) |
| 75 | Create soft links | [Ansible-Soft-Links](100%20Days%20of%20Cloud/Ansible-Soft-Links/Ansible-Soft-Links.md) |
| 81 | `replace` module | [Ansible-Replace-Module](100%20Days%20of%20Cloud/Ansible-Replace-Module/Ansible-Replace-Module.md) |
| 82 | Use gathered facts in templates | [Ansible-Facts-Gathering](100%20Days%20of%20Cloud/Ansible-Facts-Gathering/Ansible-Facts-Gathering.md) |
| 83 | Create users and groups | [Ansible-Create-User&Groups](100%20Days%20of%20Cloud/Ansible-Create-User%26Groups/Ansible-Create-User%26Groups.md) |
| 84 | Set up Apache + PHP | [Ansible-Setup-HTTPD-PHP](100%20Days%20of%20Cloud/Ansible-Setup-HTTPD-PHP/Ansible-Setup-HTTPD-PHP.md) |

### 🏗️ Terraform (AWS)

AWS infrastructure as code: EC2, VPC, IAM, S3, DynamoDB, SNS/SQS, Kinesis, KMS, Secrets Manager, CloudWatch, plus workspaces, modules, locals and symlinked configs.

| Day | Task | Solution |
|:---:|---|---|
| 76 | Create a security group | [Terraform-Create-Security-Group](100%20Days%20of%20Cloud/Terraform-Create-Security-Group/Terraform-Create-Security-Group.md) |
| 77 | Create an EC2 instance with a generated key pair | [Terraform-Create-EC2](100%20Days%20of%20Cloud/Terraform-Create-EC2/Terraform-Create-EC2.md) |
| 78 | EC2 in a private VPC | [Terraform-Create-EC2-Private-VPC](100%20Days%20of%20Cloud/Terraform-Create-EC2-Private-VPC/Terraform-Create-EC2-Private-VPC.md) |
| 79 | DynamoDB table with an IAM access policy | [Terraform-Attach-IAM-Policy-to-DynamoDB](100%20Days%20of%20Cloud/Terraform-Attach-IAM-Policy-to-DynamoDB/Terraform-Attach-IAM-Policy-to-DynamoDB.md) |
| 80 | EC2 + CloudWatch CPU alarm | [Terraform-Create-CloudWatch-Alarm](100%20Days%20of%20Cloud/Terraform-Create-CloudWatch-Alarm/Terrafrom-Create-CloudWatch-Alarm.md) |
| 85 | VPC and subnet with explicit `depends_on` | [Terraform-Create-VPC&Subnet](100%20Days%20of%20Cloud/Terraform-Create-VPC%26Subnet/Terraform-Create-VPC%26Subnet.md) |
| 86 | Force-recreate an EC2 instance with `-replace` | [Terraform-Replace-Exisitng-EC2](100%20Days%20of%20Cloud/Terraform-Replace-Exisitng-EC2/Terraform-Replace-Existing-EC2.md) |
| 87 | Deploy multiple EC2 instances | [Terraform-Deploy-Multiple-EC2](100%20Days%20of%20Cloud/Terraform-Deploy-Multiple-EC2/Terraform-Deploy-Multiple-EC2.md) |
| 88 | Attach an Elastic IP to EC2 | [Terraform-Attach-Elastic-IP](100%20Days%20of%20Cloud/Terraform-Attach-Elastic-IP/Terraform-Attach-Elastic-IP.md) |
| 89 | Create an AMI and launch EC2 from it | [Terraform-EC2-with-custom-AMI](100%20Days%20of%20Cloud/Terraform-EC2-with-custom-AMI/Terrafrom-EC2-with-custom-AMI.md) |
| 90 | Kinesis stream with CloudWatch alarm | [Terraform-Stream-Kinesis-to-CloudWatch](100%20Days%20of%20Cloud/Terraform-Stream-Kinesis-to-CloudWatch/Terraform-Stream-Kinesis-Data-to-CloudWatch.md) |
| 91 | Migrate data to a new S3 bucket | [Terraform-Sync-Data-to-S3](100%20Days%20of%20Cloud/Terraform-Sync-Data-to-S3/Terraform-Sync-Data-to-S3.md) |
| 92 | S3 bucket with `prevent_destroy` | [Terraform-Prevent-S3-Deletion](100%20Days%20of%20Cloud/Terraform-Prevent-S3-Deletion/Terraform-Prevent-S3-Deletion.md) |
| 93 | Grant EC2 access to S3 via an instance profile | [Terraform-EC2-Access-to-S3](100%20Days%20of%20Cloud/Terraform-EC2-Access-to-S3/Terraform-EC2-Access-to-S3.md) |
| 94 | S3 lifecycle rules | [Terraform-S3-Lifecycle-Management](100%20Days%20of%20Cloud/Terraform-S3-Lifecycle-Management/Terraform-S3-Lifecycle-Management.md) |
| 95 | Subscribe SQS to SNS | [Terraform-Integrate-SNS-with-SQS-for-Messaging](100%20Days%20of%20Cloud/Terraform-Integrate-SNS-with-SQS-for-Messaging/Terraform-Integrate-SNS-with-SQS-for-messaging.md) |
| 96 | IAM role with a policy | [Terraform-IAM-Role-with-Inline-Policy](100%20Days%20of%20Cloud/Terraform-IAM-Role-with-Inline-Policy/Terraform-IAM-Role-with-Inline-Policy.md) |
| 97 | IAM user with a `local-exec` provisioner | [Terraform-Provision-IAM-User](100%20Days%20of%20Cloud/Terraform-Provision-IAM-User/Terraform-Provision-IAM-User.md) |
| 98 | IAM role allowing EC2 to publish to SNS | [Terraform-Send-Notifications-from-IAM-to-SNS](100%20Days%20of%20Cloud/Terraform-Send-Notifications-from-IAM-to-SNS/Terraform-Send-Notification-from-IAM-to-SNS.md) |
| 99 | IAM access to Secrets Manager from EC2 | [Terraform-Access-Secret-Manger](100%20Days%20of%20Cloud/Terraform-Access-Secret-Manger/Terraform-Access-Secret-Manager.md) |
| 100 | CloudWatch alarm publishing to SNS | [Terraform-Configure-Cloudwatch-to-Trigger-SNS-Alert](100%20Days%20of%20Cloud/Terraform-Configure-Cloudwatch-to-Trigger-SNS-Alert/Terraform-Configure-Cloudwatch-to-Trigger-SNS-Alert.md) |
| 101 | DynamoDB via a CloudFormation stack | [Terraform-Create-DynamoDB-Using-CloudFormation](100%20Days%20of%20Cloud/Terraform-Create-DynamoDB-Using-CloudFormation/Terrafrom-Create-DynamoDB-using-CloudFormation.md) |
| 102 | DynamoDB table for a To-Do app | [Terraform-Managing-Scalable NoSQL-with-DynamoDB](100%20Days%20of%20Cloud/Terraform-Managing-Scalable%20NoSQL-with-DynamoDB/Terrform-Managing-Scalable-NoSQL-with-DynamoDB.md) |
| 103 | Kinesis Firehose to S3 ingestion pipeline | [Terraform-RealTme-Data-Ingestion-Pipeline-with-Kinesis-Firehose](100%20Days%20of%20Cloud/Terraform-RealTme-Data-Ingestion-Pipeline-with-Kinesis-Firehose/Terraform-RealTime-Data-Ingestion-Pipeline-with-Kinesis-Firehose.md) |
| 104 | Enforce IAM naming conventions | [Terraform-Enforcing-IAM-Naming-Standards-and-Permissions](100%20Days%20of%20Cloud/Terraform-Enforcing-IAM-Naming-Standards-and-Permissions/Terraform-Enforcing-IAM-Naming-Standards-and-Permissions.md) |
| 105 | Secure streaming with Kinesis, STS and S3 | [Terraform-Streaming-Secure-Data-with-Kinesis-STS-and-S3](100%20Days%20of%20Cloud/Terraform-Streaming-Secure-Data-with-Kinesis-STS-and-S3/Terraform-Streaming-Secure-data-with-Kinesis-STS-and-S3.md) |
| 106 | Encryption at rest with KMS | [Terraform-Implementing-Encryption-at-Rest-with-AWS-KMS](100%20Days%20of%20Cloud/Terraform-Implementing-Encryption-at-Rest-with-AWS-KMS/Terraform-Implementing-Encryption-at-Rest-with-AWS-KMS.md) |
| 107 | Multi-tier stack: DynamoDB, SNS and SSM Parameter Store | [Terraform-Deploying-Multi-Tier-Architecture](100%20Days%20of%20Cloud/Terraform-Deploying-Multi-Tier-Architecture/Terraform-Deploying-Multi-Tier-Architecture.md) |
| 108 | Multiple S3 buckets with fine-grained policies | [Terraform-Multiple-S3-with-Fine-Grained-Access-Policies](100%20Days%20of%20Cloud/Terraform-Multiple-S3-with-Fine-Grained-Access-Policies/Terraform-Multiple-S3-with-Fine-Grained-Access-Policies.md) |
| 109 | Static website hosting on S3 | [Terraform-Static-Website-on-S3-with-Custom-Config](100%20Days%20of%20Cloud/Terraform-Static-Website-on-S3-with-Custom-Config/Terraform-Static-Website-on-S3-with-custom-config.md) |
| 110 | Store a DB password in Secrets Manager | [Terraform-Storing-Accessing-Sensitive-Data-Security-with-AWS-Secrets-Manager](100%20Days%20of%20Cloud/Terraform-Storing-Accessing-Sensitive-Data-Security-with-AWS-Secrets-Manager/Terraform-Storing-Accessing-Sensitive-Data-Seculry-with-AWS-Secrets-Manager.md) |
| 111 | Workspaces for environment isolation | [Terraform-Managing-Workspaces-for-Environment-Isolation](100%20Days%20of%20Cloud/Terraform-Managing-Workspaces-for-Environment-Isolation/Terraform-Managing-Workspaces-for-Environment-Isolation.md) |
| 112 | Data pipeline with failure alerting | [Terraform-Alerting-CI-CD-Pipelines](100%20Days%20of%20Cloud/Terraform-Alerting-CI-CD-Pipelines/Terraform-Alerting-CI-CD-Pipelines.md) |
| 113 | Local values in an event-driven stack | [Terraform-Implementing-Local-Variables](100%20Days%20of%20Cloud/Terraform-Implementing-Local-Variables/Terraform-Implementing-Local-Variables.md) |
| 114 | Reusable modules + workspaces | [Terraform-Create-Modules](100%20Days%20of%20Cloud/Terraform-Create-Modules/Terraform-Create-Modules.md) |
| 115 | Environment-specific modular deployments | [Terraform-Managing-CI-CD-Pipelines](100%20Days%20of%20Cloud/Terraform-Managing-CI-CD-Pipelines/Terraform-Managing-CI-CD-Pipelines.md) |
| 116 | Share configuration with symlinks | [Terraform-Managing-Terraform-Codes-with-Symlinks](100%20Days%20of%20Cloud/Terraform-Managing-Terraform-Codes-with-Symlinks/Terraform-Managing-Terraform-Codes-with-Symlinks.md) |

## 🚀 How to use this repo

1. Pick a topic above and open the task's `.md` file.
2. Read the problem statement at the top, then follow the **Solution** steps.
3. Check the `Screenshot/` folder to compare against the expected output.

> ⚠️ Hostnames, users, passwords, IPs, and AMI IDs in these solutions belong to KodeKloud's temporary lab environment. Treat them as examples and change them before using anything in a real environment.

## 🔜 Next up

- **50 Days of Amazon CLI**: AWS CLI tasks (coming soon).

## 🙏 Acknowledgements

Task scenarios are from [KodeKloud](https://kodekloud.com/) and the KodeKloud Engineer platform. The solutions and notes are mine.
