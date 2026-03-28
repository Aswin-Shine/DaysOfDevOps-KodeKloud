The Nautilus DevOps team is practicing some of the Ansible modules and creating and testing different Ansible playbooks to accomplish tasks. Recently they started testing an Ansible file module to create soft links on all app servers. Below you can find more details about it.

Write a playbook.yml under /home/thor/ansible directory on jump host, an inventory file is already present under /home/thor/ansible directory on jump host itself. Using this playbook accomplish below given tasks:

Create an empty file /opt/devops/blog.txt on app server 1; its user owner and group owner should be tony. Create a symbolic link of source path /opt/devops to destination /var/www/html.

Create an empty file /opt/devops/story.txt on app server 2; its user owner and group owner should be steve. Create a symbolic link of source path /opt/devops to destination /var/www/html.

Create an empty file /opt/devops/media.txt on app server 3; its user owner and group owner should be banner. Create a symbolic link of source path /opt/devops to destination /var/www/html.

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
- name: Setup files and symbolic links on app servers
  hosts: all
  become: yes
  tasks:
    - name: Ensure /opt/devops directory exists
      ansible.builtin.file:
        path: /opt/devops
        state: directory
        mode: '0755'

    # Task for App Server 1
    - name: Create blog.txt on App Server 1
      ansible.builtin.file:
        path: /opt/devops/blog.txt
        state: touch
        owner: tony
        group: tony
        mode: '0644'
      when: inventory_hostname == "stapp01"

    # Task for App Server 2
    - name: Create story.txt on App Server 2
      ansible.builtin.file:
        path: /opt/devops/story.txt
        state: touch
        owner: steve
        group: steve
        mode: '0644'
      when: inventory_hostname == "stapp02"

    # Task for App Server 3
    - name: Create media.txt on App Server 3
      ansible.builtin.file:
        path: /opt/devops/media.txt
        state: touch
        owner: banner
        group: banner
        mode: '0644'
      when: inventory_hostname == "stapp03"

    # Common task for all servers
    - name: Create symbolic link from /opt/devops to /var/www/html
      ansible.builtin.file:
        src: /opt/devops
        dest: /var/www/html
        state: link
        force: yes
```

4. Apply the playbook.yml file

```
ansible-playbook -i inventory playbook.yml
```

5. To verfiy the task.

```
ansible all -i inventory -a "ls -l /opt/devops"
ansible all -i inventory -a "ls -l /var/www/html"
```
