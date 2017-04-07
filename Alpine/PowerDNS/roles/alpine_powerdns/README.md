Role Name
=========

Configure PowerDNS (authoritive and/or recursor)  on Apline Linux

Requirements
------------

A connection to a postgresql database for the authoritive server. Use alainvanhoof/alpine_postgresql for example

Role Variables
--------------

* pg_db_name:                pdns
* pg_db_user:                pdnsuser
* pg_db_pass:                pdnspass
* pg_listen_addr:            "'127.0.0.1'"
* pdns_auth_listen_addr:     127.0.0.1
* pdns_auth_listen_port:     53
* pdns_recursor_listen_addr: 127.0.0.1
* pdns_recursor_listen_port: 53
* pdns_recursor_forward_zones : ".=8.8.8.8"

Dependencies
------------

For the autoritive server : alainvanhoof/alpine_postgresql

Example Playbook
----------------

A host running the authorative server on interface eth1 using postgresql listening on 127.0.0.1:

- hosts: dev-powerdns-01
  become: true
  vars:
    pg_db_name: pdns
    pg_db_user: pdnsuser
    pg_db_pass: pdnspass
    pg_listen_addr: "'127.0.0.1'"
  roles:
    - { role: alpine_postgresql }
    - { role: alpine_powerdns, pdns_authoritive: true, pdns_postgresql: true, pdns_auth_listen_addr: "{{ ansible_eth1.ipv4.address }}" }

A host running the recursor that uses 10.0.0.11 to resolve thee powerdns.net zone:

- hosts: dev-powerdns-02
  become: true
  roles:
    - { role: alpine_powerdns, pdns_recursor: true, pdns_recursor_listen_addr: "{{ ansible_eth1.ipv4.address }}", pdns_recursor_forward_zones: "powerdns.net=10.0.0.11" }

A host running both authorative (on 127.0.0.1) and recursor (on eth1) using posgresql running on the same host:

- hosts: dev-powerdns-03
  become: true
  vars:
    pg_db_name: pdns
    pg_db_user: pdnsuser
    pg_db_pass: pdnspass
    pg_listen_addr: "'127.0.0.1'"
  roles:
    - { role: alpine_postgresql }
    - { role: alpine_powerdns, pdns_recursor: true, pdns_authoritive: true, pdns_postgresql: true, pdns_recursor_listen_addr: "{{ ansible_eth1.ipv4.address }}", pdns_auth_listen_addr: 127.0.0.1, pdns_recursor_forward_zones: "powerdns.net=127.0.0.1" }
...

License
-------

BSD

Author Information
------------------

Alain van Hoof : alain+ansible@lafeberhof.nl
