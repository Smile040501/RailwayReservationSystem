CREATE GROUP station_master;

REVOKE ALL ON PROCEDURE add_railway_station,
    add_schedule,
    update_train_status
FROM PUBLIC;

GRANT ALL ON TABLE railway_station TO station_master;
GRANT ALL ON TABLE schedule TO station_master;
GRANT ALL ON TABLE train TO station_master;
GRANT ALL ON TABLE seat TO station_master;

GRANT EXECUTE ON PROCEDURE add_railway_station,
    add_schedule,
    update_train_status
TO station_master;

CREATE USER qpr IN GROUP station_master PASSWORD 'qpr';
CREATE USER pst IN GROUP station_master PASSWORD 'pst';
