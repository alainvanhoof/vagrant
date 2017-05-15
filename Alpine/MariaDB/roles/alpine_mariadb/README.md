Role Name
=========

This role creates a running MariaDB instance or running MariaDB master/slave cluster (2 nodes) on Alpine Linux

Requirements
------------

To run the "agent-less" ansible against Alpine Linux it needs python, sudo and iproute2 install (use apk).

Role Variables
--------------

* mariadb_slave: undefined
* mariadb_master: undefined
* mariadb_name: undefined
* mariadb_user: undefined
* mariadb_pass: undefined
* mariadb_listen_addr: undefined
* mariadb_master_addr: undefined
* mariadb_repl_user: "repl"
* mariadb_repl_pass: "repl"

Dependencies
------------

Example Playbook
----------------

Create a Master/Slave database testdb on dev-mariadb-01 (master) and dev-mariadb-02 (slave):
```yaml
- hosts: dev-mariadb-01
  become: true
  roles:
    - { role: alpine_mariadb, mariadb_master: yes, mariadb_name: testdb, mariadb_user: user, mariadb_pass: pass, mariadb_listen_addr: "{{ ansible_eth1.ipv4.address }}" }
    
- hosts: dev-postgresql-02
  become: true
  roles:
    - { role: alpine_mariadb, mariadb_slave: yes, mariadb_name: testdb, mariadb_master_addr: '10.0.0.12', mariadb_listen_addr: "{{ ansible_eth1.ipv4.address }}" }
```
Create a standalone MariaDB on dev-mariadb-03 listing only on localhost
```yaml
- hosts: dev-postgresql-03
  become: true
  roles:
    - { role: alpine_mariadb, mariadb_listen_addr: "127.0.0.1" }
```


License
-------

BSD

Author Information
------------------

Alain van Hoof : alain+ansible@lafeberhof.nl
