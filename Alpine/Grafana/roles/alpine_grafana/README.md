Role Name
=========

This role creates a running and compiled from source Grafana instance.

Requirements
------------

To run the "agent-less" ansible against Alpine Linux it needs python, sudo and iproute2 installed (use apk).

Role Variables
--------------

Dependencies
------------

Example Playbook
----------------

Install grafana (runs on port 3000)

```yaml
- hosts: dev-grafana-01
  become: true
  roles:
    - { role: alpine_grafana }
```
---

License
-------

BSD

Author Information
------------------

Alain van Hoof : alain+ansible@lafeberhof.nl
