-- Trigger function for automatic seat allocation
CREATE OR REPLACE FUNCTION try_alloc_seat()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$
DECLARE
    train_name VARCHAR(100);
    src_station_name VARCHAR(100);
    dest_station_name VARCHAR(100);
    waiting_ticket RECORD;
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Extract train_name, source/destination station names
        SELECT get_train_name(NEW.train_no)
        INTO train_name;
        SELECT src_station_name(NEW.src_station_id)
        INTO src_station_name;
        SELECT dest_station_name(NEW.dest_station_id)
        INTO dest_station_name;

        -- Try allocating seat to this passenger
        CALL alloc_seat(NEW.pnr, train_name, src_station_name, dest_station_name, NEW.date);
    ELSEIF TG_OP = 'UPDATE' AND NEW.booking_status = 'Cancelled' THEN
        -- Loop all the passengers in the waiting queue in order of booking time
        FOR waiting_ticket IN (SELECT pnr,
                                    train_no,
                                    src_station_id
                                    dest_station_id,
                                    date
                                FROM ticket
                                WHERE booking_status = 'Waiting'
                                    AND date = NEW.date
                                    AND train_no = NEW.train_no
                                ORDER BY booking_time ASC)
        LOOP
            -- Extract train_name, source/destination station names
            SELECT get_train_name(waiting_ticket.train_no)
            INTO train_name;
            SELECT src_station_name(waiting_ticket.src_station_id)
            INTO src_station_name;
            SELECT dest_station_name(waiting_ticket.dest_station_id)
            INTO dest_station_name;

            -- Try allocating seat to this passenger
            CALL alloc_seat(waiting_ticket.pnr, train_name, src_station_name, dest_station_name, waiting_ticket.date);
        END LOOP;
    END IF;

    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER seat_allocation
AFTER INSERT OR UPDATE
ON ticket
FOR EACH ROW
EXECUTE FUNCTION try_alloc_seat();
