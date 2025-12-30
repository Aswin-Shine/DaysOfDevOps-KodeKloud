The Nautilus application development team has been working on a project repository /opt/cluster.git. This repo is cloned at /usr/src/kodekloudrepos on storage server in Stratos DC. They recently shared the following requirements with DevOps team:

a. Create a new branch nautilus in /usr/src/kodekloudrepos/news repo from master and copy the /tmp/index.html file (on storage server itself). Add/commit this file in the new branch and merge back that branch to the master branch. Finally, push the changes to origin for both of the branches.

Solution:

```
ssh to natasha@ststor01
sudo su
cd /usr/src/kodekloudrepos/news
git branch -a
git checkout -b nautilus
cp /tmp/index.html ./
git status
git add .
git commit -m "adding index.html"
git push origin nautilus
git checkout master
git merge nautilus
git push origin master
```
