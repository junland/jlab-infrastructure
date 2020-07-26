# Ansible

This directory contains configurations using `Ansible`

## Roles

`base` - Common base configuration role.
`gateway` - Gateway role to route various network services.
`apps` - Various applications that I like to run.

## How to use.

1. Create inventory file

```
# inventory.ini
[servers]
<ip>
<ip>
```

2. Create playbook file

```
# inventory.ini
- hosts: servers
  roles:
    - role1
    - role2
```

3. Execute against playbook and inventory file.

```
ansible-playbook -k -u root --inventory-file ./inventory.ini inventory.ini
```
