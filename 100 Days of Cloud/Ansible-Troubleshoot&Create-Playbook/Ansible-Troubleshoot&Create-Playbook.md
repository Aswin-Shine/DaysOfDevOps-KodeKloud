An Ansible playbook needs completion on the jump host, where a team member left off. Below are the details:

The inventory file /home/thor/ansible/inventory requires adjustments. The playbook must run on App Server 3 in Stratos DC. Update the inventory accordingly.

Create a playbook /home/thor/ansible/playbook.yml. Include a task to create an empty file /tmp/file.txt on App Server 3.

Solution :

1. Get into the ansible folder and change the inventory file

```
cd ansible
ls

vi inventory
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

- name: Create an emptyfile
  hosts: all
  tasks:
  - name: Create an empty file in /tmp
    file:
      path: /tmp/file.txt
      state: touch

cat playbook.yml
```

4. Apply the playbook.yml file

```
ansible-playbook -i inventory playbook.yml
```

5. Check the task has executed

```
ansible all -i inventory -a "ls -l /tmp"
```
