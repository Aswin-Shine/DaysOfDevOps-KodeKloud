The Nautilus Application development team wanted to test some applications on app servers in Stratos Datacenter. They shared some pre-requisites with the DevOps team, and packages need to be installed on app servers. Since we are already using Ansible for automating such tasks, please perform this task using Ansible as per details mentioned below:

Create an inventory file /home/thor/playbook/inventory on jump host and add all app servers in it.

Create an Ansible playbook /home/thor/playbook/playbook.yml to install samba package on all app servers using Ansible yum module.

Make sure user thor should be able to run the playbook on jump host.

Solution :

1. Create an inventory file and add servers as managed nodes.

```
cd home/thor/playbook
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

- name: Install packages
  hosts: all
  become: yes
  tasks:
    - name: Install zip
      dnf:
        name: zip
        state: present
```

4. Apply the playbook.yml file

```
ansible-playbook -i inventory playbook.yml
```
