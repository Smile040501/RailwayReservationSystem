-- Get train name given train number
CREATE OR REPLACE FUNCTION get_train_name(in_train_no INT)
RETURNS VARCHAR(100)
LANGUAGE PLPGSQL
AS $$
DECLARE
    in_train_name VARCHAR(100);
BEGIN
    SELECT name
    INTO in_train_name
    FROM train
    WHERE train_no = in_train_no;

    ASSERT in_train_name IS NOT NULL, 'Train with number "' || in_train_no || '" does not exist!';
    RETURN in_train_name;
END;
$$;

-- Get station name given station id
CREATE OR REPLACE FUNCTION get_station_name(in_station_id INT)
RETURNS VARCHAR(100)
LANGUAGE PLPGSQL
AS $$
DECLARE
    in_station_name VARCHAR(100);
BEGIN
    SELECT name
    INTO in_station_name
    FROM railway_station
    WHERE station_id = in_station_id;

    ASSERT in_station_name IS NOT NULL, 'Station with id "' || in_station_id || '" does not exist!';
    RETURN in_station_name;
END;
$$;

-- Get Day of the week
CREATE OR REPLACE FUNCTION get_day(in_date DATE)
RETURNS DAY_OF_WEEK
LANGUAGE PLPGSQL
AS $$
BEGIN
    RETURN TRIM(TO_CHAR(in_date, 'Day'))::DAY_OF_WEEK;
END;
$$;

-- Get train_no given train name
CREATE OR REPLACE FUNCTION get_train_no(train_name VARCHAR(100))
RETURNS INT
LANGUAGE PLPGSQL
AS $$
DECLARE
    in_train_no INT;
BEGIN
    SELECT train_no
    INTO in_train_no
    FROM train
    WHERE name = train_name;

    ASSERT in_train_no IS NOT NULL, 'Train with name "' || train_name || '" does not exist!';
    RETURN in_train_no;
END;
$$;

-- Get station id given station name
CREATE OR REPLACE FUNCTION get_station_id(station_name VARCHAR(100))
RETURNS INT
LANGUAGE PLPGSQL
AS $$
DECLARE
    in_station_id INT;
BEGIN
    SELECT station_id
    INTO in_station_id
    FROM railway_station
    WHERE name = station_name;

    ASSERT in_station_id IS NOT NULL, 'Station with name "' || station_name || '" does not exist!';
    RETURN in_station_id;
END;
$$;

-- Get user id given user email
CREATE OR REPLACE FUNCTION get_user_id(user_email VARCHAR(100))
RETURNS INT
LANGUAGE PLPGSQL
AS $$
DECLARE
    in_user_id INT;
BEGIN
    SELECT user_id
    INTO in_user_id
    FROM users
    WHERE email_id = user_email;

    ASSERT in_user_id IS NOT NULL, 'User with email "' || user_email || '" does not exist!';
    RETURN in_user_id;
END;
$$;

-- Get schedule ids from current_station to dest_station
CREATE OR REPLACE FUNCTION get_sch_ids(
    in_train_no INT,
    in_src_station_id INT,
    in_dest_station_id INT
)
RETURNS INT[]
LANGUAGE PLPGSQL
AS $$
DECLARE
    sch_ids INT[] := ARRAY[]::INT[];
    curr_sch_id INT;
    dest_sch_id INT;
    tmp_next_station_id INT;
    idx INT;
BEGIN
    -- getting the sch_ids
	SELECT sch_id
    INTO curr_sch_id
    FROM schedule
	WHERE train_no = in_train_no
		AND curr_station_id = in_src_station_id;

    SELECT sch_id
    INTO dest_sch_id
    FROM schedule
	WHERE train_no = in_train_no
		AND curr_station_id = in_dest_station_id;

	idx := 1;
	WHILE curr_sch_id != dest_sch_id LOOP
		sch_ids[idx] := curr_sch_id;
		idx := idx + 1;

		SELECT next_station_id
        INTO tmp_next_station_id
        FROM schedule
		WHERE sch_id = curr_sch_id;

		SELECT sch_id
        INTO curr_sch_id
        FROM schedule
		WHERE train_no = in_train_no
			AND curr_station_id = tmp_next_station_id;
	END LOOP;

    -- sch_ids[idx] := dest_sch_id;

    RETURN sch_ids;
END;
$$;

-- Validate Ticket PNR
CREATE OR REPLACE FUNCTION validate_pnr(in_pnr UUID)
RETURNS VOID
LANGUAGE PLPGSQL
AS $$
DECLARE
    in_ticket_pnr UUID;
BEGIN
    SELECT pnr
    INTO in_ticket_pnr
    FROM ticket
    WHERE pnr = in_pnr;

    ASSERT in_ticket_pnr IS NOT NULL, 'Ticket with PNR "' || in_pnr || '" does not exist!';
END;
$$;


-- Get Days of a train at a station
CREATE OR REPLACE FUNCTION get_days_at_station(in_station_id INT, in_train_no INT)
RETURNS DAY_OF_WEEK[]
LANGUAGE PLPGSQL
AS $$
DECLARE
    in_journey_day INT;
    result DAY_OF_WEEK[] := ARRAY[]::DAY_OF_WEEK[];
    len INT;
    i INT;
BEGIN
    SELECT (arr_time).day_of_journey
    INTO in_journey_day
    FROM schedule
    WHERE train_no = in_train_no
        AND curr_station_id = in_station_id;

    SELECT week_days
    INTO result
    FROM train
    WHERE train_no = in_train_no;

    SELECT ARRAY_LENGTH(result, 1)
    INTO len;

    FOR i IN 1 .. (len) LOOP
        result[i] := (result[i] @+ (in_journey_day - 1));
    END LOOP;

    RETURN result;
END;
$$ ;
