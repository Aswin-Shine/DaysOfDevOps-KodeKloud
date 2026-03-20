One of the Nautilus DevOps team members is working on to develop a role for httpd installation and configuration. Work is almost completed, however there is a requirement to add a jinja2 template for index.html file. Additionally, the relevant task needs to be added inside the role. The inventory file ~/ansible/inventory is already present on jump host that can be used. Complete the task as per details mentioned below:

a. Update ~/ansible/playbook.yml playbook to run the httpd role on App Server 2.

b. Create a jinja2 template index.html.j2 under /home/thor/ansible/role/httpd/templates/ directory and add a line This file was created using Ansible on <respective server> (for example This file was created using Ansible on stapp01 in case of App Server 1). Also please make sure not to hard code the server name inside the template. Instead, use inventory_hostname variable to fetch the correct value.

c. Add a task inside /home/thor/ansible/role/httpd/tasks/main.yml to copy this template on App Server 2 under /var/www/html/index.html. Also make sure that /var/www/html/index.html file's permissions are 0644.

d. The user/group owner of /var/www/html/index.html file must be respective sudo user of the server (for example tony in case of stapp01).

Solution :

1. Get into the ansible folder and use ping module to ping all servers.

```
cd /home/thor/ansible
ls

ansbile all -m ping -i inventory
```

2. Get into the role folder to create the index.html.j2 file

```

cd role/httpd/templates
ls

vi index.html.j2
  This file was created using ansible on {{ inventory_hostname }}
```

4. Udpate the main playbook file now.

```
cd /home/thor/ansible/role/httpd/tasks
ls

vi main.yml
  - name: Deploy index.html
    template:
      src: index.html.j2
      dest: /var/www/html/index.html
      owner: "{{ansible_user }}"
      group: "{{ansible_user }}"
      mode: '0644'

```

5. Edit the playbook file & and run the playbook.

```
vi playbook.yml
  - hosts: stapp02
    become: yes
    become_user: root
    roles:
      - role/httpd
```

6. To verify the task.

```
curl stapp03
```
