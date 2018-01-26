Role Name
=========

This role creates a running nginx instance with an option to install php5/php7 served by hph-fpm

Requirements
------------

To run the "agent-less" ansible against Alpine Linux it needs python, sudo and iproute2 installed (use apk).

Role Variables
--------------

* php5: undefined
* php7: undefined

Dependencies
------------

Example Playbook
----------------

Install nginx with a index.html page on port 80

- hosts: dev-nginx-01
  become: true
  roles:
    - { role: alpine_nginx }

Install nginx with php5, a index.html and index.php (with phpinfo) on port 80

- hosts: dev-nginx-02
  become: true
  roles:
    - { role: alpine_nginx, php5: yes }

Install nginx with php7, a index.html and index.php (with phpinfo) on port 80

- hosts: dev-nginx-03
  become: true
  roles:
    - { role: alpine_nginx, php7: yes }


License
-------

BSD

Author Information
------------------

Alain van Hoof : alain+ansible@lafeberhof.nl
