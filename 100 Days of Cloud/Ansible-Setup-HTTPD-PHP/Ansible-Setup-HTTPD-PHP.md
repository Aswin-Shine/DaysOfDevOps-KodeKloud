Nautilus Application development team wants to test the Apache and PHP setup on one of the app servers in Stratos Datacenter. They want the DevOps team to prepare an Ansible playbook to accomplish this task. Below you can find more details about the task.

There is an inventory file ~/playbooks/inventory on jump host.

Create a playbook ~/playbooks/httpd.yml on jump host and perform the following tasks on App Server 1.

a. Install httpd and php packages (whatever default version is available in yum repo).

b. Change default document root of Apache to /var/www/html/myroot in default Apache config /etc/httpd/conf/httpd.conf. Make sure /var/www/html/myroot path exists (if not please create the same).

c. There is a template ~/playbooks/templates/phpinfo.php.j2 on jump host. Copy this template to the Apache document root you created as phpinfo.php file and make sure user owner and the group owner for this file is apache user.

d. Start and enable httpd service.

Solution :

1. Create an inventory file and add servers as managed nodes.

```
cd ~/playbooks
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
vi httpd.yaml

- name: Install and Configure Apache with PHP
  hosts: stapp01
  become: true
  tasks:
    - name: Install httpd and php packages
      ansible.builtin.yum:
        name:
          - httpd
          - php
        state: present

    - name: Ensure custom document root directory exists
      ansible.builtin.file:
        path: /var/www/html/myroot
        state: directory
        owner: apache
        group: apache
        mode: '0755'

    - name: Update DocumentRoot in httpd.conf
      ansible.builtin.replace:
        path: /etc/httpd/conf/httpd.conf
        regexp: '^DocumentRoot "/var/www/html"'
        replace: 'DocumentRoot "/var/www/html/myroot"'

    - name: Update Directory index in httpd.conf
      ansible.builtin.replace:
        path: /etc/httpd/conf/httpd.conf
        regexp: '<Directory "/var/www/html">'
        replace: '<Directory "/var/www/html/myroot">'

    - name: Deploy phpinfo.php from template
      ansible.builtin.template:
        src: ~/playbooks/templates/phpinfo.php.j2
        dest: /var/www/html/myroot/phpinfo.php
        owner: apache
        group: apache
        mode: '0644'

    - name: Start and enable httpd service
      ansible.builtin.service:
        name: httpd
        state: started
        enabled: true
```

4. Apply the playbook.yml file

```
ansible-playbook -i inventory playbook.yml
```

5. Verify the task.

```
curl stapp01
```
