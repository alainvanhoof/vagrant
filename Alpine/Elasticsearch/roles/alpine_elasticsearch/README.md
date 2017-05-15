Role Name
=========

This role creates a running Elasticsearch instance or a running Elasticsearch cluster on Alpine Linux

Requirements
------------

To run the "agent-less" ansible against Alpine Linux it needs python, sudo and iproute2 install (use apk).

Role Variables
--------------

* elasticsearch_version: 5.4.0
* es_listen_addr: 127.0.0.1
* es_cluster_name: cluster01

Dependencies
------------

Example Playbook
----------------

Create an Elasticsearch node (dev-es-01) and add extra nodes (dev-es-02,dev-es-03,dev-es-04) where the unicast host is the IP where th node dev-es-01 listens.

```yaml
- hosts: dev-es-01
  become: true
  roles:
    - { role: alpine_elasticsearch, es_listen_addr: "{{ ansible_eth1.ipv4.address }}" }

- hosts: dev-es-02,dev-es-03,dev-es-04
  become: true
  roles:
    - { role: alpine_elasticsearch, es_listen_addr: "{{ ansible_eth1.ipv4.address }}", es_unicast_host: 10.0.0.11 }
```

License
-------

BSD

Author Information
------------------

Alain van Hoof : alain+ansible@lafeberhof.nl
