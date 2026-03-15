The Nautilus DevOps team wants to install and set up a simple httpd web server on all app servers in Stratos DC. Additionally, they want to deploy a sample web page for now using Ansible only. Therefore, write the required playbook to complete this task. Find more details about the task below.

We already have an inventory file under /home/thor/ansible directory on jump host. Create a playbook.yml under /home/thor/ansible directory on jump host itself.

Using the playbook, install httpd web server on all app servers. Additionally, make sure its service should up and running.

Using blockinfile Ansible module add some content in /var/www/html/index.html file. Below is the content:

Welcome to XfusionCorp!

This is Nautilus sample file, created using Ansible!

Please do not modify this file manually!

The /var/www/html/index.html file's user and group owner should be apache on all app servers.

The /var/www/html/index.html file's permissions should be 0655 on all app servers.

Solution :

1. Create an inventory file and add servers as managed nodes.

```
cd home/thor/ansible
ls

vi inventory

stapp01 ansible_host=stapp01 ansible_user=tony ansible_ssh_pass='Ir0nM@n' ansible_ssh_common_args='-o StrictHostKeyChecking=no'

stapp02 ansible_host=stapp02 ansible_user=steve ansible_ssh_pass='Am3ric@' ansible_ssh_common_args='-o StrictHostKeyChecking=no'

stapp03 ansible_host=stapp03 ansible_user=banner ansible_ssh_pass='BigGr33n' ansible_ssh_common_args='-o StrictHostKeyChecking=no'

cat inventory
```

2. Ping the sever using ansible

```
ansible all -m ping -i inventory

```

3. Create ansible playbook

```
vi playbook.yaml

- name: Install httpd in all app server
  become: yes
  hosts: all
  tasks:
    - name: Installing httpd
      yum:
        name: httpd
        state: present

    - name: Create index file
      blockinfile:
        path: /var/www/html/index.html
        owner: apache
        group: apache
        mode: '0655'
        create: true
        block: |
          Welcome to XfusionCorp!
          This is Nautilus sample file, created using Ansible!
          Please do not modify this file manually!

    - name: Start apache
      service:
        name: httpd
        state: started
```

4. Apply the playbook.yml file

```
ansible-playbook -i inventory playbook.yml
```

5. To verify the task

```

curl stapp01
curl stapp02
curl stapp03
```
