CREATE GROUP users;

GRANT SELECT ON TABLE train TO users;

GRANT SELECT ON TABLE railway_station TO users;

GRANT SELECT ON TABLE schedule TO users;

GRANT SELECT ON TABLE seat TO users;

GRANT SELECT ON TABLE reservation TO users;

GRANT SELECT ON TABLE passenger TO users;

GRANT EXECUTE ON PROCEDURE book_tickets,
    cancel_booking TO users;

GRANT EXECUTE ON FUNCTION get_trains,
    get_train_schedule,
    get_trains_schedule_at_station,
    get_fare,
    get_passenger_details,
    num_seats_available_from_src_to_dest,
    get_ticket_status,
    get_train_status TO users;

CREATE USER abc IN GROUP users PASSWORD 'abc';

CREATE USER def IN GROUP users PASSWORD 'def';

CREATE GROUP passengers;

GRANT SELECT ON TABLE train TO passengers;

GRANT SELECT ON TABLE railway_station TO passengers;

GRANT SELECT ON TABLE schedule TO passengers;

GRANT SELECT ON TABLE ticket TO passengers;

CREATE USER ghi IN GROUP passengers PASSWORD 'ghi';

CREATE USER jkl IN GROUP passengers PASSWORD 'jkl';

CREATE GROUP radmin;

GRANT ALL ON DATABASE project TO radmin;

CREATE USER mno IN GROUP radmin PASSWORD 'mno';

CREATE USER pqr IN GROUP radmin PASSWORD 'pqr';
