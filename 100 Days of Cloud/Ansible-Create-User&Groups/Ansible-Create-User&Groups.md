Several new developers and DevOps engineers just joined the xFusionCorp industries. They have been assigned the Nautilus project, and as per the onboarding process we need to create user accounts for new joinees on at least one of the app servers in Stratos DC. We also need to create groups and make new users members of those groups. We need to accomplish this task using Ansible. Below you can find more information about the task.

There is already an inventory file ~/playbooks/inventory on jump host.

On jump host itself there is a list of users in ~/playbooks/data/users.yml file and there are two groups — admins and developers —that have list of different users. Create a playbook ~/playbooks/add_users.yml on jump host to perform the following tasks on app server 1 in Stratos DC.

a. Add all users given in the users.yml file on app server 1.

b. Also add developers and admins groups on the same server.

c. As per the list given in the users.yml file, make each user member of the respective group they are listed under.

d. Make sure home directory for all of the users under developers group is /var/www (not the default i.e /var/www/{USER}). Users under admins group should use the default home directory (i.e /home/devid for user devid).

e. Set password B4zNgHA7Ya for all of the users under developers group and ksH85UJjhb for of the users under admins group. Make sure to use the password given in the ~/playbooks/secrets/vault.txt file as Ansible vault password to encrypt the original password strings. You can use ~/playbooks/secrets/vault.txt file as a vault secret file while running the playbook (make necessary changes in ~/playbooks/ansible.cfg file).

f. All users under admins group must be added as sudo users. To do so, simply make them member of the wheel group as well.

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
vi add_users.yml

- name: Manage Users and Groups on App Server 2
  hosts: stapp02
  become: true
  tasks:
    - name: Load user and group data from users.yml
      ansible.builtin.include_vars:
        file: ~/playbooks/data/users.yml

    - name: Create required groups
      ansible.builtin.group:
        name: "{{ item }}"
        state: present
      loop:
        - admins
        - developers

    - name: Add Admin users to admins and wheel groups
      ansible.builtin.user:
        name: "{{ item }}"
        groups: admins,wheel
        state: present
        # Using the password_hash filter for security
        password: "{{ 'ksH85UJjhb' | password_hash('sha512') }}"
        shell: /bin/bash
      loop: "{{ admins }}"

    - name: Add Developer users with custom home directory
      ansible.builtin.user:
        name: "{{ item }}"
        groups: developers
        home: /var/www
        move_home: false
        state: present
        password: "{{ 'B4zNgHA7Ya' | password_hash('sha512') }}"
        shell: /bin/bash
      loop: "{{ developers }}"
```

5. Edit the ansible.cgf and add this

```
vault_password_file = ~/playbooks/secrets/vault.txt
```

6. Apply the playbook.yml file

```
ansible-playbook -i inventory add_users.yml
```
