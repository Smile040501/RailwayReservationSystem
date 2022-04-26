-- Helper functions/procedures for other different queries

-- 1. Users can book tickets for multiple passengers
CREATE OR REPLACE PROCEDURE book_tickets(
    in_name VARCHAR(100)[],
    in_age INT[],
    src_station VARCHAR(100),
    dest_station VARCHAR(100),
    train_name VARCHAR(100),
    in_date DATE,
  	in_email VARCHAR(100),
    in_seat_type SEAT_TYPE[]
)
LANGUAGE PLPGSQL
AS $$
DECLARE
    fare INT;
    src_id INT;
    dest_id INT;
    train_number INT;
    in_user_id INT;
    temp_id UUID;
    num_names INT;
    src_station_days DAY_OF_WEEK[];
    in_day DAY_OF_WEEK[];
    in_pids UUID[];
BEGIN
    -- Input validation
    ASSERT ARRAY_LENGTH(in_name, 1) = ARRAY_LENGTH(in_age, 1), 'Number of names and age for the passengers do not match';

	-- Extracting different variables
    SELECT get_user_id(in_email)
    INTO in_user_id ;

    SELECT get_train_no(train_name)
    INTO train_number;

    SELECT get_station_id(src_station)
    INTO src_id;

    SELECT get_station_id(dest_station)
    INTO dest_id;

    -- Get days on which the train runs from source station
    SELECT get_days_at_station(src_id, train_number)
    INTO src_station_days;

    -- Get day of the week on which the ticket is booked
    SELECT get_day(in_date)
    INTO in_day;

    -- Check if the train runs on the day of the booking
    ASSERT in_day = ANY(src_station_days), 'The train "' || train_name || '" does not run on the date "' || (in_date::TEXT) || '" at the station "' || (src_station::TEXT) || '"';

    -- Get cost of the ticket
    SELECT get_fare(train_name, src_station, dest_station)
    INTO fare;

    -- Storing lengths of arrays
    SELECT ARRAY_LENGTH(in_name, 1)
    INTO num_names;

    FOR i IN 1 .. num_names LOOP
        -- Create new passenger
        INSERT INTO passenger(
                name,
                age
            )
        VALUES (
                in_name[i],
                in_age[i]
            )
        RETURNING pid INTO in_pids[i];

        -- Create tickets for each passenger with initial booking_status as 'Waiting'
        INSERT INTO ticket(
                cost,
                src_station_id,
                dest_station_id,
                train_no,
                user_id,
                date,
                pid
            )
        VALUES (
                fare,
                src_id,
                dest_id,
                train_number,
                in_user_id,
                in_date,
                in_pids[i]
            );
    END LOOP;

	COMMIT;
END;
$$;


-- 2. Cancel booking
CREATE OR REPLACE PROCEDURE cancel_booking(in_pnr UUID)
LANGUAGE PLPGSQL
AS $$
BEGIN
    -- DEPRECATED CODE
	-- Update reservation table
	-- UPDATE reservation
	-- SET pnr = NULL,
	-- 	booked = FALSE
	-- WHERE pnr = in_pnr;

    SELECT validate_pnr(in_pnr);

	-- Update ticket table
	UPDATE ticket
	SET booking_status = 'Cancelled'
	WHERE pnr = in_pnr;

	COMMIT;
END;
$$;


-- 3. Confirm the status and allocate a seat to the ticket of the passenger - Admin
CREATE OR REPLACE PROCEDURE allocate_seat(
    in_pnr UUID,
    in_train_name VARCHAR(100),
    in_src_station_name VARCHAR(100),
    in_dest_station_name VARCHAR(100),
    in_date DATE,
    in_seat_type SEAT_TYPE
)
LANGUAGE PLPGSQL
AS $$
DECLARE
    in_train_no INT;
    in_src_station_id INT;
    in_dest_station_id INT;
    sch_ids INT[] := ARRAY[]::INT[];
    reservation_info RECORD;
    val INT;
    tmp_seat_id INT;
    idx INT;
    in_total_seats INT;
    -- debug_cnt INT := 0;
    in_days DAY_OF_WEEK;
    src_station_days DAY_OF_WEEK[];
    in_day DAY_OF_WEEK;
BEGIN
    -- Getting the declared values
    SELECT get_train_no(in_train_name)
    INTO in_train_no;

    SELECT get_station_id(in_src_station_name)
    INTO in_src_station_id;

    SELECT get_station_id(in_dest_station_name)
    INTO in_dest_station_id;

    -- RAISE NOTICE 'src_station_id %, dest_station_id %', in_src_station_id, in_dest_station_id;

    -- Get days on which the train runs from source station
    SELECT get_days_at_station(in_src_station_id, in_train_no)
    INTO src_station_days;

    -- Get day of the week on which the ticket is booked
    SELECT get_day(in_date)
    INTO in_day;

    -- Check if the train runs on the day of the booking
    ASSERT in_day = ANY(src_station_days), 'The train "' || in_train_name || '" does not run on the date "' || (in_date::TEXT) || '" at the station "' || (in_src_station_name::TEXT) || '"';

    -- Getting the sch_ids
    SELECT get_sch_ids(in_train_no, in_src_station_id, in_dest_station_id)
    INTO sch_ids;

    -- total seats
    SELECT total_seats
    INTO in_total_seats
    FROM train
    WHERE train_no = in_train_no;

    -- Create a tmp table for reservation
    CREATE TEMPORARY TABLE reservation (
        sch_id INT,
        seat_id INT,
        res_seat_type SEAT_TYPE,
        booked BOOLEAN
    ) ON COMMIT DROP;

    -- Add all possible pairs of schedule_id and seat_id to the tmp table
    -- TODO: Try to make this short
    FOR idx IN 1 .. in_total_seats
    LOOP
        FOREACH val IN ARRAY sch_ids
        LOOP
            INSERT INTO reservation(sch_id, seat_id, res_seat_type, booked)
            VALUES (val, idx, 'AC', False), (val, idx, 'NON-AC', False);
        END LOOP;
    END LOOP;

    -- Updating booked values
    FOR reservation_info IN (SELECT src_station_id AS travel_src_station,
                                dest_station_id AS travel_dest_station,
                                seat_id
                            FROM ticket
                            WHERE date = in_date
                                AND train_no = in_train_no
                                AND booking_status = 'Booked'
                                AND seat_type = in_seat_type
                            )
    LOOP
        FOREACH val IN ARRAY get_sch_ids(
                                in_train_no,
                                reservation_info.travel_src_station,
                                reservation_info.travel_dest_station
                            )
        LOOP
            UPDATE reservation
            SET booked = True
            WHERE sch_id = val
                AND seat_id = reservation_info."seat_id"
                AND res_seat_type = in_seat_type;
            -- debug_cnt := debug_cnt + 1;
            -- RAISE NOTICE 'inside loop seat_id %, sch_id %', reservation_info."seat_id", val;
        END LOOP;

    END LOOP;

    -- RAISE NOTICE 'debug_cnt %', debug_cnt;

    -- NOTE :- source and destination stations are
    -- source and dest of journey, not of the train

    -- Getting the best seat in tmp_seat_id

    -- This will give the empty seats for the given path
    -- `SELECT seat_id FROM reservation WHERE (sch_id = ANY (sch_ids))
    -- GROUP BY seat_id HAVING SUM((booked)::INT) = 0;`

    -- Now selecting best seat out of all the empty seats
    SELECT seat_id
    INTO tmp_seat_id
    FROM reservation
    GROUP BY seat_id
    HAVING seat_id IN (
        -- all empty seats as written above
        -- (in the current range)
        SELECT seat_id
        FROM reservation
        WHERE (sch_id = ANY(sch_ids))
        AND res_seat_type = in_seat_type
        GROUP BY seat_id
        HAVING COALESCE(SUM((booked)::INT), 0) = 0
    )
    ORDER BY COALESCE(SUM(booked::INT), 0) DESC
    LIMIT 1;

    -- RAISE NOTICE 'best seat %', tmp_seat_id;

    IF tmp_seat_id IS NOT NULL THEN
        UPDATE ticket
        SET booking_status = 'Booked',
            seat_id = tmp_seat_id,
            seat_type = in_seat_type
        WHERE pnr = in_pnr;
    END IF;

    COMMIT;
END;
$$;


-- 4. Select appropriate train(s) for a given source and destination and date
CREATE OR REPLACE FUNCTION get_trains(
    src_station VARCHAR(100),
    dest_station VARCHAR(100),
    in_date DATE
)
RETURNS TABLE (
    train_no INT,
    train_name VARCHAR(100),
    seats_available TEXT
)
LANGUAGE PLPGSQL
AS $$
DECLARE
    src_id INT;
    dest_id INT;
    in_day DAY_OF_WEEK;
BEGIN
	-- Get train Number
    SELECT get_station_id(src_station)
    INTO src_id;

    SELECT get_station_id(dest_station)
    INTO dest_id;

    SELECT get_day(in_date)
    INTO in_day;

    RETURN QUERY
		SELECT train.train_no,
            train.name,
            num_seats_available_from_src_to_dest(
                train.name,
                src_station,
                dest_station,
                in_date
            ) || '/' || train.total_seats  AS seats_available
		FROM train,
            schedule as s1,
            schedule as s2
		WHERE s1.curr_station_id = src_id
            AND s2.curr_station_id = dest_id
            AND s1.dep_time < s2.arr_time
            AND s1.train_no = s2.train_no
            AND train.train_no = s1.train_no
            AND in_day = ANY(get_days_at_station(src_id, train.train_no));
END;
$$;


-- 5. Given a train give a schedule for it
CREATE OR REPLACE FUNCTION get_train_schedule(train_name VARCHAR(100))
RETURNS TABLE (
    current_station TEXT,
    next_station TEXT,
    arrival_time DAY_TIME,
    departure_time DAY_TIME
)
LANGUAGE PLPGSQL
AS $$
DECLARE
    train_number INT;
BEGIN
	-- Get train Number
    SELECT get_train_no(train_name)
    INTO train_number;

    RETURN QUERY
        WITH temp_table AS (
            SELECT train_no,
                curr_station_id,
                next_station_id,
                arr_time,
                dep_time
            FROM schedule
            WHERE train_no = train_number
        )
        SELECT rs1.name || ', ' || rs1.city || ', ' || rs1.state AS current_station,
            rs2.name || ', ' || rs2.city || ', ' || rs2.state AS next_station,
            sch.arr_time AS arrival_time,
            sch.dep_time AS departure_time
        FROM temp_table AS sch
            JOIN railway_station AS rs1 ON rs1.station_id = sch.curr_station_id
            LEFT JOIN railway_station AS rs2 ON rs2.station_id = sch.next_station_id
        ORDER BY sch.arr_time ASC;
END;
$$;


-- 6. Give the schedule of all the trains at a station
CREATE OR REPLACE FUNCTION get_trains_schedule_at_station(in_station_name VARCHAR(100))
RETURNS TABLE(
    train_no INT,
    train_name VARCHAR(100),
    source_station TEXT,
    next_station TEXT,
    destination_station TEXT,
    arrival_time DAY_TIME,
    departure_time DAY_TIME,
    delay_time INTERVAL,
    total_seats INT,
    week_days DAY_OF_WEEK[]
)
LANGUAGE PLPGSQL
AS $$
DECLARE
    in_station_id INT;
BEGIN
    -- Get station id
    SELECT get_station_id(in_station_name)
    INTO in_station_id;

    RETURN QUERY
        WITH temp_table AS (
            SELECT sch.train_no,
                sch.next_station_id,
                sch.arr_time,
                sch.dep_time,
                sch.delay_time
            FROM schedule as sch
            WHERE sch.curr_station_id = in_station_id
        )
        SELECT st.train_no,
            tt.name AS train_name,
            src.name || ', ' || src.city || ', ' || src.state AS source_station,
            nxt.name || ', ' || nxt.city || ', ' || nxt.state AS next_station,
            dest.name || ', ' || dest.city || ', ' || dest.state AS destination_station,
            st.arr_time AS arrival_time,
            st.dep_time AS departure_time,
            st.delay_time,
            tt.total_seats,
            tt.week_days
        FROM temp_table AS st
            JOIN train AS tt ON st.train_no = tt.train_no
            JOIN railway_station AS src ON tt.src_station_id = src.station_id
            LEFT JOIN railway_station AS nxt ON st.next_station_id = nxt.station_id
            JOIN railway_station AS dest ON tt.dest_station_id = dest.station_id
        ORDER BY st.train_no ASC;
END;
$$;


-- 7. Fare of the train route for a particular train from source to destination
CREATE OR REPLACE FUNCTION get_fare(
  	train_name VARCHAR(100),
  	src_station VARCHAR(100),
  	dest_station VARCHAR(100)
)
RETURNS INT
LANGUAGE PLPGSQL
AS $$
DECLARE
	train_number INT;
    src_id INT;
    dest_id INT;
    total_fare INT;
    src_fare INT;
    dest_fare INT;
BEGIN
    SELECT get_train_no(train_name)
    INTO train_number;

    SELECT get_station_id(src_station)
    INTO src_id;

    SELECT get_station_id(dest_station)
    INTO dest_id;

    SELECT fare
    INTO src_fare
    FROM schedule
    WHERE curr_station_id = src_id
    	AND train_no = train_number;

    SELECT fare
    INTO dest_fare
    FROM schedule
    WHERE curr_station_id = dest_id
    	AND train_no = train_number;

    SELECT dest_fare - src_fare
    INTO total_fare;

    RETURN total_fare;
END;
$$;


-- 8. For a given PNR, give details of the journey and the passenger.
CREATE OR REPLACE FUNCTION get_passenger_details(in_pnr UUID)
RETURNS TABLE(
    pnr UUID,
    pid UUID,
    passenger_name VARCHAR(100),
    passenger_age INT,
    train_no INT,
    train_name VARCHAR(100),
    source_station TEXT,
    destination_station TEXT,
    date DATE,
    cost INT,
    user_name VARCHAR(100),
    user_email VARCHAR(100),
    user_mobile VARCHAR(20),
    booking_status BOOKING_STATUS,
    seat_no INT,
    seat_type SEAT_TYPE
)
LANGUAGE PLPGSQL
AS $$
BEGIN
    SELECT validate_pnr(in_pnr);

    RETURN QUERY
        WITH temp_table AS (
            SELECT *
            FROM ticket as tic
            WHERE tic.pnr = in_pnr
        )
        SELECT t.pnr,
            t.pid,
            p.name AS passenger_name,
            p.age AS passenger_age,
            t.train_no,
            tr.name AS train_name,
            rs1.name || ', ' || rs1.city || ', ' || rs1.state AS source_station,
            rs2.name || ', ' || rs2.city || ', ' || rs2.state AS destination_station,
            t.date,
            t.cost,
            u.username AS user_name,
            u.email_id AS user_email,
            u.mobile_no AS user_mobile,
            t.booking_status,
            s.seat_no,
            s.seat_type
        FROM temp_table AS t
            JOIN passenger AS p ON t.pid = p.pid
            JOIN train AS tr ON t.train_no = tr.train_no
            JOIN railway_station AS rs1 ON rs1.station_id = t.src_station_id
            JOIN railway_station AS rs2 ON rs2.station_id = t.dest_station_id
            JOIN users AS u ON u.user_id = t.user_id
            LEFT JOIN seat AS s ON s.seat_id = t.seat_id;
END;
$$;


-- 9. No. of seats available for a particular train from src to dest on a particular date
CREATE OR REPLACE FUNCTION num_seats_available_from_src_to_dest(
    in_train_name VARCHAR(100),
    in_src_station_name VARCHAR(100),
    in_dest_station_name VARCHAR(100),
    in_date DATE
)
RETURNS INTEGER
LANGUAGE PLPGSQL
AS $$
DECLARE
    in_train_no INT;
    in_src_station_id INT;
    in_dest_station_id INT;
    result INT;
    booked_seats INT;
    sch_ids  integer ARRAY;
    in_total_seats INT;
BEGIN
    SELECT get_train_no(in_train_name)
    INTO in_train_no;
    SELECT get_station_id(in_src_station_name)
    INTO in_src_station_id;
    SELECT get_station_id(in_dest_station_name)
    INTO in_dest_station_id;

    -- Getting the sch_ids
    SELECT get_sch_ids(in_train_no, in_src_station_id, in_dest_station_id)
    INTO sch_ids;

    -- total seats
    SELECT total_seats
    INTO in_total_seats
    FROM train
    WHERE train_no = in_train_no;

    -- getting booked_seats values
    SELECT COUNT(DISTINCT seat_id)
    INTO booked_seats
    FROM ticket
    WHERE train_no = in_train_no
        AND booking_status = 'Booked'
        AND date = in_date
        AND (get_sch_ids(train_no, src_station_id, dest_station_id) & sch_ids) >= 1;

    SELECT in_total_seats - booked_seats
    INTO result;
    RETURN result;
END;
$$;


-- 10. Status of seat reservation: In the waiting list or confirmed?
CREATE OR REPLACE FUNCTION get_ticket_status(in_pnr UUID)
RETURNS BOOKING_STATUS
LANGUAGE PLPGSQL
AS $$
DECLARE
	status BOOKING_STATUS;
BEGIN
    SELECT validate_pnr(in_pnr);

    SELECT booking_status
    INTO status
    FROM ticket
    WHERE pnr = in_pnr;

    RETURN status;
END;
$$;


-- 11. What is the status of a given train at a given station? Delayed or On-time…
CREATE OR REPLACE FUNCTION get_train_status(
    train_name VARCHAR(100),
    station_name VARCHAR(100)
)
RETURNS INTERVAL
LANGUAGE PLPGSQL
AS $$
DECLARE
    in_train_no INT;
    in_station_id INT;
    train_status INTERVAL;
BEGIN
    -- Get the train no
    SELECT get_train_no(train_name)
    INTO in_train_no;

    -- Get the station id
    SELECT get_station_id(station_name)
    INTO in_station_id;

    -- Get the train status
    SELECT delay_time
    INTO train_status
    FROM schedule
    WHERE train_no = in_train_no
        AND curr_station_id = in_station_id;

    RETURN train_status;
END;
$$;


-- 12. Add a new railway station - Admin
CREATE OR REPLACE PROCEDURE add_railway_station(
    in_name VARCHAR(100),
    in_city VARCHAR(100),
    in_state VARCHAR(100)
)
LANGUAGE PLPGSQL
AS $$
BEGIN
    INSERT INTO railway_station(name, city, state)
    VALUES (in_name, in_city, in_state);
    COMMIT;
END;
$$;

-- 13. Add a new schedule for a new route - Admin
CREATE OR REPLACE PROCEDURE add_schedule(
    in_name VARCHAR(100),
    in_seats INT[],
    in_seat_types SEAT_TYPE[],
    in_week_days DAY_OF_WEEK[],
    in_stations VARCHAR(100)[],
    in_arr_time DAY_TIME[],
    in_dep_time DAY_TIME[],
    in_fares NUMERIC(7, 2)[]
)
LANGUAGE PLPGSQL
AS $$
DECLARE
    in_train_no INT;
    in_station_ids INT[] := ARRAY[]::INT[];
    num_stations INT;
    num_seats INT;
    seat_rec RECORD;
    sch_rec RECORD;
    journey_len INT;
    num_week_days INT;
BEGIN
    -- Assuming `Admin` will also give the arr. time for src_station and dep. time for dest station
    -- Initially giving delay_time as 0 to all the schedules

    -- Input validation
    ASSERT ARRAY_LENGTH(in_stations, 1) = ARRAY_LENGTH(in_arr_time, 1), 'Number of stations and arrival times do not match';
    ASSERT ARRAY_LENGTH(in_stations, 1) = ARRAY_LENGTH(in_dep_time, 1), 'Number of stations and departure times do not match';
    ASSERT ARRAY_LENGTH(in_stations, 1) = ARRAY_LENGTH(in_fares, 1), 'Number of stations and fares for each station do not match';
    ASSERT ARRAY_LENGTH(in_seats, 1) = ARRAY_LENGTH(in_seat_types, 1), 'Number of seats and seat types do not match';

    -- Storing lengths of arrays
    num_stations := ARRAY_LENGTH(in_stations, 1);
    num_seats := ARRAY_LENGTH(in_seats, 1);
    num_week_days := ARRAY_LENGTH(in_week_days, 1);

    ASSERT num_week_days > 0, 'No week days specified!';

    -- Input validation for timings and fare
    FOR i IN 1 .. num_stations LOOP
        IF in_dep_time[i] < in_arr_time[i] THEN
            RAISE EXCEPTION 'Departure time of the station "%" cannot be before arrival time', in_stations[i];
        END IF;
        IF in_dep_time[i] >= in_arr_time[i + 1] THEN
            RAISE EXCEPTION 'Departure time of the station "%" is greater than arrival time of the next station', in_stations[i];
        END IF;
        IF in_fares[i] >= in_fares[i + 1] THEN
            RAISE EXCEPTION 'Fare of the station "%" is greater than the fare of next station', in_stations[i];
        END IF;
    END LOOP;

	-- validating days
    SELECT (in_dep_time[ARRAY_LENGTH(in_dep_time, 1)].day_of_journey - 1)
    INTO journey_len;

    ASSERT journey_len <= 7 , 'Journey length cannot be more than 7 days';

    IF (num_week_days > 1) THEN
        FOR i IN 1 .. (num_week_days - 1) LOOP
            ASSERT ((in_week_days[i + 1] @- in_week_days[i]) > (journey_len)), 'Given running days of the train in incorrect';
        END LOOP;
    	ASSERT ((in_week_days[1] @- in_week_days[num_week_days]) > (journey_len)), 'Given running days of the train in incorrect';
    END IF;

    -- Get the station ids corresponding to station names
    FOR i IN 1 .. num_stations LOOP
        in_station_ids[i] := (
            SELECT get_station_id(in_stations[i])
        );
    END LOOP;

    -- Insert and make a new train
    INSERT INTO train(
            name,
            src_station_id,
            dest_station_id,
            total_seats,
            week_days
        )
    VALUES (
            in_name,
            in_station_ids[1],
            in_station_ids[num_stations],
            num_seats,
            in_week_days
        )
    RETURNING train_no INTO in_train_no;

    -- Insert the schedule
    FOR i IN 1 .. num_stations LOOP
        INSERT INTO schedule(
                train_no,
                curr_station_id,
                next_station_id,
                arr_time,
                dep_time,
                fare,
                delay_time
            )
        VALUES (
                in_train_no,
                in_station_ids[i],
                in_station_ids[i + 1],
                in_arr_time[i],
                in_dep_time[i],
                in_fares[i],
                INTERVAL '0'
            );
    END LOOP;

    -- Insert the seats
    FOR i IN 1 .. num_seats LOOP
        INSERT INTO seat(
                seat_no,
                train_no,
                seat_type
            )
        VALUES (
                in_seats[i],
                in_train_no,
                in_seat_types[i]
            );
    END LOOP;

    -- DEPRECATED CODE
    -- Insert into reservation table
    -- FOR d in 0 .. 6 LOOP
    --     FOR sch_rec IN (SELECT sch_id FROM schedule WHERE train_no = in_train_no) LOOP
    --         FOR seat_rec IN (SELECT seat_id FROM seat WHERE train_no = in_train_no) LOOP
    --             INSERT INTO reservation(
    --                     seat_id,
    --                     sch_id,
    --                     pnr,
    --                     booked,
    --                     date
    --                 )
    --             VALUES (
    --                     seat_rec.seat_id,
    --                     sch_rec.sch_id,
    --                     NULL,
    --                     FALSE,
    --                     CURRENT_DATE + d
    --                 );
    --         END LOOP;
    --     END LOOP;
    -- END LOOP;

    COMMIT;
END;
$$;


-- 14. Add a new user
CREATE OR REPLACE PROCEDURE add_user(
  	in_name VARCHAR(100),
  	in_email VARCHAR(100),
  	in_age INT,
  	in_mobile VARCHAR(20)
)
LANGUAGE PLPGSQL
AS $$
BEGIN
	INSERT INTO users(username, email_id, age, mobile_no)
    VALUES (in_name, in_email, in_age, in_mobile);
    COMMIT;
END;
$$;


-- 15. Update train status
CREATE OR REPLACE PROCEDURE update_train_status(
  	train_name VARCHAR(100),
  	station_name VARCHAR(100),
  	in_delay INTERVAL
)
LANGUAGE PLPGSQL
AS $$
DECLARE
	train_id INT;
	station_id INT;
BEGIN
	SELECT get_train_no(train_name)
    INTO train_id;

	SELECT get_station_id(station_name)
    INTO station_id;

	UPDATE schedule
	SET delay_time = in_delay
	WHERE train_no = train_id
		AND curr_station_id = station_id;
    COMMIT;
END;
$$;


-------------------------------------------------------------------------------------------------------------------------------------------------
-- Aditya
-- 1, 5, 7, 10, 15
-------------------------------------------------------------------------------------------------------------------------------------------------
-- Satyam
-- 2, 3, 9, 14
-------------------------------------------------------------------------------------------------------------------------------------------------
-- Mayank
-- 6, 8, 11, 12, 13
-------------------------------------------------------------------------------------------------------------------------------------------------
