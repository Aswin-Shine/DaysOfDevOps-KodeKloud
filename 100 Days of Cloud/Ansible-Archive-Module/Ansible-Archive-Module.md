The Nautilus DevOps team has some data on jump host in Stratos DC that they want to copy on all app servers in the same data center. However, they want to create an archive of data and copy it to the app servers. Additionally, there are some specific requirements for each server. Perform the task using Ansible playbook as per requirements mentioned below:

Create a playbook.yml under /home/thor/ansible on jump host, an inventory file is already placed under /home/thor/ansible/ on Jump Server itself.

Create an archive official.tar.gz (make sure archive format is tar.gz) of /usr/src/finance/ directory ( present on each app server ) and copy it to /opt/finance/ directory on all app servers.

The user and group owner of archive official.tar.gz should be tony for App Server 1, steve for App Server 2 and banner for App Server 3.

Solution :

1. Create an inventory file and add servers as managed nodes.

```
cd home/thor/ansible
ls

vi inventory

stapp01 ansible_hostname=stapp01 ansible_user=tony ansible_ssh_pass='Ir0nM@n' ansible_ssh_common_args='-o StrictHostKeyChecking=no'

stapp02 ansible_hostname=stapp02 ansible_user=steve ansible_ssh_pass='Am3ric@' ansible_ssh_common_args='-o StrictHostKeyChecking=no'

stapp03 ansible_hostname=stapp03 ansible_user=banner ansible_ssh_pass='BigGr33n' ansible_ssh_common_args='-o StrictHostKeyChecking=no'

cat inventory
```

2. Ping the sever using ansible

```
ansible all -m ping -i inventory

```

3. Create ansible playbook

```
vi playbook.yaml

- name: Create and copy finance archives
  hosts: all
  become: true
  tasks:
    - name: Create tar.gz archive of /usr/src/finance
      community.general.archive:
        path: /usr/src/finance/
        dest: /opt/finance/demo.tar.gz
        format: gz
        owner: "{{ ansible_user }}"
        group: "{{ ansible_user }}"
        mode: '0644'
```

4. Apply the playbook.yml file

```
ansible-playbook -i inventory playbook.yml
```

5. To verfiy the task.

```
ansible all -i inventory -a "ls -l /opt/finance"
```
