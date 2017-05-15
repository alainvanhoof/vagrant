Role Name
=========

This role creates a running Filebeat instance on Alpine Linux

Requirements
------------

To run the "agent-less" ansible against Alpine Linux it needs python, sudo and iproute2 install (use apk).

Role Variables
--------------

* filebeat_version: 5.4.0-linux-x86_64
* ship_addr: 127.0.0.1
* ship_port: 9200

Dependencies
------------

To get the logs to elasticsearch an elasticsearch (cluster) instance is needed. Use for example alainvanhoof/alpine_elasticsearch to create one._

Example Playbook
----------------

Install a running filebeat instance on a host and ship the logs to elasticsearch running on 10.0.0.11:9200:

```yaml
- hosts: dev-filebeat-01
  become: true
  roles:
    - { role: alpine_filebeat, ship_addr: 10.0.0.11 }
```

License
-------

BSD

Author Information
------------------

Alain van Hoof : alain+ansible@lafeberhof.nl
