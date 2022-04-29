CREATE GROUP users;

REVOKE ALL ON PROCEDURE book_tickets,
    cancel_booking,
    allocate_seat
FROM PUBLIC;

REVOKE ALL ON FUNCTION get_passenger_details
FROM PUBLIC;

GRANT ALL ON TABLE users TO users;
GRANT ALL ON TABLE passenger TO users;
GRANT SELECT ON TABLE ticket TO users;

GRANT EXECUTE ON PROCEDURE book_tickets,
    cancel_booking
TO users;

GRANT EXECUTE ON FUNCTION get_passenger_details
TO users;
