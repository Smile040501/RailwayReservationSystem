DROP DATABASE railway_reservation_system;
CREATE DATABASE railway_reservation_system;

-- Users
DROP ROLE IF EXISTS "abc@abc.com";
DROP ROLE IF EXISTS "def@def.com";
DROP ROLE IF EXISTS "ghi@ghi.com";
DROP ROLE IF EXISTS "jkl@jkl.com";
DROP ROLE IF EXISTS "mno@mno.com";

-- dbAdmin
DROP ROLE IF EXISTS "mno";
DROP ROLE IF EXISTS "pqr";

-- Passengers
DROP ROLE IF EXISTS "passenger";

-- Station Masters
DROP ROLE IF EXISTS "qpr";
DROP ROLE IF EXISTS "pst";

REVOKE ALL ON DATABASE railway_reservation_system FROM users;
REVOKE ALL ON DATABASE railway_reservation_system FROM dbAdmin;
REVOKE ALL ON DATABASE railway_reservation_system FROM station_master;

DROP ROLE IF EXISTS users;
DROP ROLE IF EXISTS passengers;
DROP ROLE IF EXISTS dbAdmin;
DROP ROLE IF EXISTS station_master;
