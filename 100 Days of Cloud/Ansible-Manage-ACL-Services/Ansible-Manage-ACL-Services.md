There are some files that need to be created on all app servers in Stratos DC. The Nautilus DevOps team want these files to be owned by user root only; however, they also want that app-specific user to have a set of permissions to these files. All tasks must be done using Ansible only, so they need to create a playbook. Below you can find more information about the task.

Create a playbook.yml under /home/thor/ansible on jump host, an inventory file is already present under /home/thor/ansible on Jump Server itself.

Create an empty file blog.txt under /opt/devops/ directory on app server 1. Set some acl properties for this file. Using acl provide read '(r)' permissions to group tony (i.e entity is tony and etype is group).

Create an empty file story.txt under /opt/devops/ directory on app server 2. Set some acl properties for this file. Using acl provide read + write '(rw)' permissions to user steve (i.e entity is steve and etype is user).

Create an empty file media.txt under /opt/devops/ on app server 3. Set some acl properties for this file. Using acl provide read + write '(rw)' permissions to group banner (i.e entity is banner and etype is group).

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

- name: Manage ACL-based files on app servers
  hosts: all
  become: yes

  tasks:
    - name: Ensure /opt/devops directory exists
      file:
        path: /opt/devops
        state: directory
        owner: root
        group: root
        mode: '0755'

    # App Server 1 (stapp01) - blog.txt, ACL for group tony (read)
    - name: Create blog.txt on app server 1
      file:
        path: /opt/sysops/blog.txt
        state: touch
        owner: root
        group: root
        mode: '0644'
      when: inventory_hostname == "stapp01"

    - name: Set ACL for group tony on blog.txt (read only)
      acl:
        path: /opt/devops/blog.txt
        entity: tony
        etype: group
        permissions: r
        state: present
      when: inventory_hostname == "stapp01"

    # App Server 2 (stapp02) - story.txt, ACL for user steve (rw)
    - name: Create story.txt on app server 2
      file:
        path: /opt/devops/story.txt
        state: touch
        owner: root
        group: root
        mode: '0644'
      when: inventory_hostname == "stapp02"

    - name: Set ACL for user steve on story.txt (read+write)
      acl:
        path: /opt/devops/story.txt
        entity: steve
        etype: user
        permissions: rw
        state: present
      when: inventory_hostname == "stapp02"

    # App Server 3 (stapp03) - media.txt, ACL for group banner (rw)
    - name: Create media.txt on app server 3
      file:
        path: /opt/devops/media.txt
        state: touch
        owner: root
        group: root
        mode: '0644'
      when: inventory_hostname == "stapp03"

    - name: Set ACL for group banner on media.txt (read+write)
      acl:
        path: /opt/devops/media.txt
        entity: banner
        etype: group
        permissions: rw
        state: present
      when: inventory_hostname == "stapp03"
```

4. Apply the playbook.yml file

```
ansible-playbook -i inventory playbook.yml
```
