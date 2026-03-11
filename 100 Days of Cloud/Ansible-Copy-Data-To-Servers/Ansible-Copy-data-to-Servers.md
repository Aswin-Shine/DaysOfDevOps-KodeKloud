The Nautilus DevOps team needs to copy data from the jump host to all application servers in Stratos DC using Ansible. Execute the task with the following details:

a. Create an inventory file /home/thor/ansible/inventory on jump_host and add all application servers as managed nodes.

b. Create a playbook  /home/thor/ansible/playbook.yml on the jump host to copy the /usr/src/sysops/index.html file to all application servers, placing it at /opt/sysops.

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

- name: Copy files
  hosts: all
  become: yes
  tasks:
    - name: copy index.html to /opt/sysops
      copy:
       src: /usr/src/sysops/index.html
       dest: /opt/sysops
```

4. Apply the playbook.yml file

```
ansible-playbook -i inventory playbook.yml
```

5. Check the task has executed

```
ansible all -i inventory -a "ls -l /opt/sysops"
```
