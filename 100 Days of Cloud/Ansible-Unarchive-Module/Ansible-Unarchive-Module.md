One of the DevOps team members has created a zip archive on jump host in Stratos DC that needs to be extracted and copied over to all app servers in Stratos DC itself. Because this is a routine task, the Nautilus DevOps team has suggested automating it. We can use Ansible since we have been using it for other automation tasks. Below you can find more details about the task:

We have an inventory file under /home/thor/ansible directory on jump host, which should have all the app servers added already.

There is a zip archive /usr/src/data/nautilus.zip on jump host.

Create a playbook.yml under /home/thor/ansible/ directory on jump host itself to perform the below given tasks.

Unzip /usr/src/data/nautilus.zip archive in /opt/data/ location on all app servers.

Make sure the extracted data must has the respective sudo user as their user and group owner, i.e tony for app server 1, steve for app server 2, banner for app server 3.

The extracted data permissions must be 0755.

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

- name: Deploy and unzip nautilus archive
  hosts: all
  become: yes
  tasks:
    - name: Extract nautilus.zip to /opt/data
      ansible.builtin.unarchive:
        src: /usr/src/data/nautilus.zip
        dest: /opt/data/
        remote_src: no
        owner: "{{ ansible_user }}"
        group: "{{ ansible_user }}"
        mode: '0755'
```

4. Apply the playbook.yml file

```
ansible-playbook -i inventory playbook.yml
```

5. To verfiy the task.

```
ansible all -i inventory -a "ls -l /opt/data"
```
