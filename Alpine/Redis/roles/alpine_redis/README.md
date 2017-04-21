Role Name
=========

This role creates a running Redis instance with an option to install a Replication Set.

Requirements
------------

To run the "agent-less" ansible against Alpine Linux it needs python, sudo and iproute2 installed (use apk).

Role Variables
--------------

* redis_listen_addr: undefined
* redis_slaveof: undefined (use IP of master to define)

Dependencies
------------

Example Playbook
----------------

Install a Redis instance listening on localhost
```yaml
- hosts: dev-redis-01
  become: true
  roles:
    - { role: alpine_redis }
```
Install a Redis replication set of 3
```yaml
- hosts: dev-redis-02
  become: true
  roles:
    - { role: alpine_redis, redis_listen_addr: "{{ ansible_eth1.ipv4.address }}" }

- hosts: dev-redis-03,dev-redis-04
  become: true
  roles:
    - { role: alpine_redis, redis_slaveof: 10.0.0.11, redis_listen_addr: "{{ ansible_eth1.ipv4.address }}" }
```

License
-------

BSD

Author Information
------------------

Alain van Hoof : alain+ansible@lafeberhof.nl
