The Nautilus DevOps team had a discussion about, how they can train different team members to use Ansible for different automation tasks. There are numerous ways to perform a particular task using Ansible, but we want to utilize each aspect that Ansible offers. The team wants to utilise Ansible's conditionals to perform the following task:

An inventory file is already placed under /home/thor/ansible directory on jump host, with all the Stratos DC app servers included.

Create a playbook /home/thor/ansible/playbook.yml and make sure to use Ansible's when conditionals statements to perform the below given tasks.

Copy blog.txt file present under /usr/src/devops directory on jump host to App Server 1 under /opt/devops directory. Its user and group owner must be user tony and its permissions must be 0755 .

Copy story.txt file present under /usr/src/devops directory on jump host to App Server 2 under /opt/devops directory. Its user and group owner must be user steve and its permissions must be 0755 .

Copy media.txt file present under /usr/src/devops directory on jump host to App Server 3 under /opt/devops directory. Its user and group owner must be user banner and its permissions must be 0755.

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

- name: Copy Data to app servers
  hosts: all
  become: yes
  tasks:
    - name: App server 1
      copy:
        src: /usr/src/devops/blog.txt
        dest: /opt/devops
        owner: tony
        group: tony
        mode: '0755'
      when: inventory_hostname == "stapp01"

    - name: App server 2
      copy:
        src: /usr/src/devops/story.txt
        dest: /opt/devops
        owner: steve
        group: steve
        mode: '0755'
      when: inventory_hostname == "stapp02"

    - name: App server 3
      copy:
        src: /usr/src/devops/media.txt
        dest: /opt/devops
        owner: banner
        group: banner
        mode: '0755'
      when: inventory_hostname == "stapp03"
```

4. Apply the playbook.yml file

```
ansible-playbook -i inventory playbook.yml
```

5. Check the task has executed

```
ansible all -i inventory -a "ls -l /opt/devops"
```
