There is some data on all app servers in Stratos DC. The Nautilus development team shared some requirement with the DevOps team to alter some of the data as per recent changes they made. The DevOps team is working to prepare an Ansible playbook to accomplish the same. Below you can find more details about the task.

Write a playbook.yml under /home/thor/ansible on jump host, an inventory is already present under /home/thor/ansible directory on Jump host itself. Perform below given tasks using this playbook:

We have a file /opt/itadmin/blog.txt on app server 1. Using Ansible replace module replace string xFusionCorp to Nautilus in that file.

We have a file /opt/itadmin/story.txt on app server 2. Using Ansiblereplace module replace the string Nautilus to KodeKloud in that file.

We have a file /opt/itadmin/media.txt on app server 3. Using Ansible replace module replace string KodeKloud to xFusionCorp Industries in that file.

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

- name: Perform text replacements on App Servers
  hosts: all
  become: true
  tasks:
    - name: Replace xFusionCorp with Nautilus on App Server 1
      ansible.builtin.replace:
        path: /opt/itadmin/blog.txt
        regexp: 'xFusionCorp'
        replace: 'Nautilus'
      when: inventory_hostname == 'stapp01'

    - name: Replace Nautilus with KodeKloud on App Server 2
      ansible.builtin.replace:
        path: /opt/itadmin/story.txt
        regexp: 'Nautilus'
        replace: 'KodeKloud'
      when: inventory_hostname == 'stapp02'

    - name: Replace KodeKloud with xFusionCorp Industries on App Server 3
      ansible.builtin.replace:
        path: /opt/itadmin/media.txt
        regexp: 'KodeKloud'
        replace: 'xFusionCorp Industries'
      when: inventory_hostname == 'stapp03'
```

4. Apply the playbook.yml file

```
ansible-playbook -i inventory playbook.yml
```
