Role Name
=========

This role creates a running Mongo instance with an option to install a Replication Set.

Requirements
------------

To run the "agent-less" ansible against Alpine Linux it needs python, sudo and iproute2 installed (use apk).

Role Variables
--------------

* mongodb_listen_addr: undefined
* mongodb_primary: undefined (use name of Replication Set to define)
* mongodb_secondary: undefined (use name of Replication Set to define)

Dependencies
------------

Example Playbook
----------------

Install a MongoDB instance listening on localhost
```yaml
- hosts: dev-mongodb-01
  become: true
  roles:
    - { role: alpine_mongodb }
```
Install a MongoDB replication set of 3
```yaml
- hosts: dev-mongodb-02
  become: true
  roles:
    - { role: alpine_mongodb, mongodb_listen_addr: "{{ ansible_eth1.ipv4.address }}", mongodb_primary: rs0}

- hosts: dev-mongodb-03,dev-mongodb-04
  become: true
  roles:
    - { role: alpine_mongodb, mongodb_listen_addr: "{{ ansible_eth1.ipv4.address }}", mongodb_secondary: rs0}

```

License
-------

BSD

Author Information
------------------

Alain van Hoof : alain+ansible@lafeberhof.nl
