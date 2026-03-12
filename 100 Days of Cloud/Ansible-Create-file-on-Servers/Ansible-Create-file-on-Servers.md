The Nautilus DevOps team is testing various Ansible modules on servers in Stratos DC. They're currently focusing on file creation on remote hosts using Ansible. Here are the details:

a. Create an inventory file ~/playbook/inventory on jump host and include all app servers.

b. Create a playbook ~/playbook/playbook.yml to create a blank file /opt/nfsdata.txt on all app servers.

c. Set the permissions of the /opt/nfsdata.txt file to 0655.

d. Ensure the user/group owner of the /opt/nfsdata.txt file is tony on app server 1, steve on app server 2 and banner on app server 3.

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

- name: A playbook
  hosts: all
  become: yes
  tasks:
    - name: App server 1
      file:
        path: /opt/nfsdata.txt
        state: touch
        owner: tony
        group: tony
        mode: '0655'
      when: inventory_hostname == "stapp01"

    - name: App server 2
      file:
        path: /opt/nfsdata.txt
        state: touch
        owner: steve
        group: steve
        mode: '0655'
      when: inventory_hostname == "stapp02"

    - name: App server 3
      file:
        path: /opt/nfsdata.txt
        state: touch
        owner: banner
        group: banner
        mode: '0655'
      when: inventory_hostname == "stapp03"
```

4. Apply the playbook.yml file

```
ansible-playbook -i inventory playbook.yml
```

5. Check the task has executed

```
ansible all -i inventory -a "ls -l /opt"
```
