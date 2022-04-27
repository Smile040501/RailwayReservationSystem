DROP DATABASE railway_reservation_system;
CREATE DATABASE railway_reservation_system;

DROP ROLE IF EXISTS abc;
DROP ROLE IF EXISTS def;
DROP ROLE IF EXISTS ghi;
DROP ROLE IF EXISTS jkl;
DROP ROLE IF EXISTS mno;
DROP ROLE IF EXISTS pqr;
DROP ROLE IF EXISTS zyx;
DROP ROLE IF EXISTS cba;
DROP ROLE IF EXISTS qpr;
DROP ROLE IF EXISTS pst;

REVOKE ALL ON DATABASE railway_reservation_system FROM users;
REVOKE ALL ON DATABASE railway_reservation_system FROM passengers;
REVOKE ALL ON DATABASE railway_reservation_system FROM dbAdmin;
REVOKE ALL ON DATABASE railway_reservation_system FROM station_master;

DROP ROLE IF EXISTS users;
DROP ROLE IF EXISTS passengers;
DROP ROLE IF EXISTS dbAdmin;
DROP ROLE IF EXISTS station_master;
