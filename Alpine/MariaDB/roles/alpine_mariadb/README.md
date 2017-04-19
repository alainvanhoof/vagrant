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
Role Name
=========

A brief description of the role goes here.

Requirements
------------

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
