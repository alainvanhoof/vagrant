Role Name
=========

This role creates a running Graphite instance without the web interface but with the graphite-API so for instance Grafana can connect.

Requirements
------------

To run the "agent-less" ansible against Alpine Linux it needs python, sudo and iproute2 installed (use apk).

Role Variables
--------------

* graphite_api_port: 8080

Dependencies
------------

Example Playbook
----------------

Install graphite with the api running on port 9090

```yaml
- hosts: dev-graphite-01
  become: true
  roles:
    - { role: alpine_graphite, graphite_api_port: 9090 }
```
---

License
-------

BSD

Author Information
------------------

Alain van Hoof : alain+ansible@lafeberhof.nl
