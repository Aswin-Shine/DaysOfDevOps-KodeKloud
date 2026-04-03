The Nautilus DevOps team is trying to setup a simple Apache web server on all app servers in Stratos DC using Ansible. They also want to create a sample html page for now with some app specific data on it. Below you can find more details about the task.

You will find a valid inventory file /home/thor/playbooks/inventory on jump host (which we are using as an Ansible controller).

Create a playbook index.yml under /home/thor/playbooks directory on jump host. Using blockinfile Ansible module create a file facts.txt under /root directory on all app servers and add the following given block in it. You will need to enable facts gathering for this task.

Ansible managed node architecture is <architecture>

(You can obtain the system architecture from Ansible's gathered facts by using the correct Ansible variable while taking into account Jinja2 syntax)

Install httpd server on all apps. After that make a copy of facts.txt file as index.html under /var/www/html directory. Make sure to start httpd service after that.

Solution :

1. Create an inventory file and add servers as managed nodes.

```
cd home/thor/playbooks
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
vi index.yml

- name: Configure Apache and deploy system facts
  hosts: all
  become: true
  gather_facts: true
  tasks:
    - name: Create facts.txt with system architecture
      ansible.builtin.blockinfile:
        path: /root/facts.txt
        create: true
        block: |
          Ansible managed node architecture is {{ ansible_architecture }}
        mode: '0644'

    - name: Install httpd server
      ansible.builtin.package:
        name: httpd
        state: present

    - name: Copy facts.txt to index.html
      ansible.builtin.copy:
        src: /root/facts.txt
        dest: /var/www/html/index.html
        remote_src: true
        mode: '0644'

    - name: Start and enable httpd service
      ansible.builtin.service:
        name: httpd
        state: started
        enabled: true
```

4. Apply the playbook.yml file

```
ansible-playbook -i inventory index.yml
```
