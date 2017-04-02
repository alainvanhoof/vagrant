INSERT INTO domains(name , type) VALUES('powerdns.net', 'NATIVE');
INSERT INTO records(domain_id, name, type, content, ttl, change_date) VALUES(1, 'powerdns.net', 'SOA', 'ns1.powerdns.net root.powerdns.net', 86400, 2017040200);
INSERT INTO records(domain_id, name, type, content, ttl, change_date) VALUES(1, 'powerdns.net', 'NS', 'ns1.powerdns.net', 86400, 2017040200);
INSERT INTO records(domain_id, name, type, content, ttl, change_date) VALUES(1, 'ns1.powerdns.net', 'A', '10.0.0.11', 3600, 2017040200);
INSERT INTO records(domain_id, name, type, content, ttl, change_date) VALUES(1, 'powerdns01.powerdns.net', 'A', '10.0.0.11', 3600, 2017040200);
INSERT INTO records(domain_id, name, type, content, ttl, change_date) VALUES(1, 'powerdns02.powerdns.net', 'A', '10.0.0.12', 3600, 2017040200);
INSERT INTO records(domain_id, name, type, content, ttl, change_date) VALUES(1, 'powerdns03.powerdns.net', 'A', '10.0.0.13', 3600, 2017040200);
