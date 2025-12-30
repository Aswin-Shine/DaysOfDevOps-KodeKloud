The Nautilus development team shared with the DevOps team requirements for new application development, setting up a Git repository for that project. Create a Git repository on Storage server in Stratos DC as per details given below:

1. Install git package using yum on Storage server.

2. After that create a bare git repository /opt/ecommerce.git (use the exact name as asked).

Solution:

1. SSH to natasha@ststor01
2. Install git:

```
sudo su
yum install git -y
```

3. Create repo:

```
cd /opt/
```

4. Initialize git:

```
git init --bare ecommerce.git
```
