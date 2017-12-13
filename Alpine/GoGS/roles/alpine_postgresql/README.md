Role Name
=========

This role creates a running PostgreSQL instance or running PostgreSQL cluster (2 nodes) on Alpine Linux

Requirements
------------

To run the "agent-less" ansible against Alpine Linux it needs python, sudo and iproute2 install (use apk).

Role Variables
--------------

* pg_primary: undefined
* pg_standby_addr: undefined
* pg_standby: undefined
* pg_primary_addr: undefined
* pg_version: "10"
* pg_db_name: "example"
* pg_db_user: "example"
* pg_db_pass: "example"
* pg_db_priv: "ALL"
* pg_db_encoding: "UTF8"
* pg_listen_addr: "'*'"
* pg_data_dir: "/var/lib/postgresql/{{ pg_version}}/data"
* pg_repl_user: "repl"
* pg_repl_pass: "repl"

Dependencies
------------

Example Playbook
----------------

Create a cluster on dev-postgresql-01 and dev-postgresql-02 with a initial database test:
```yaml
- hosts: dev-postgresql-01
  become: true
  roles:
    - { role: alpine_postgresql, pg_primary: true, pg_standdy_addr: "IP or HOSTNAME of standby", pg_db_name: test, pg_db_user: testuser, pg_db_pass: testpass }
- hosts: dev-postgresql-02
  become: true
  roles:
    - { role: alpine_postgresql, pg_standby: true, pg_primary_addr: "IP or HOSTNAME of primary" }
```
Create a standalone postgreSQL on dev-postgresql-03 listing only on localhost
```yaml
- hosts: dev-postgresql-03
  become: true
  roles:
    - { role: alpine_postgresql, pg_listen_addr: localhost, pg_db_name: test2, pg_db_user: test2user, pg_db_pass: test2pass }
```


License
-------

BSD

Author Information
------------------

Alain van Hoof : alain+ansible@lafeberhof.nl
