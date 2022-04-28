-- Tables
CREATE TABLE IF NOT EXISTS railway_station (
    station_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS train (
    train_no SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    src_station_id INT NOT NULL,
    dest_station_id INT NOT NULL,
    total_seats INT NOT NULL CHECK(total_seats >= 0),
    -- Week days on which this train will follow its schedule and start from the source station
    week_days DAY_OF_WEEK [] NOT NULL,
    FOREIGN KEY(src_station_id) REFERENCES railway_station(station_id) ON DELETE CASCADE,
    FOREIGN KEY(dest_station_id) REFERENCES railway_station(station_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email_id VARCHAR(100) NOT NULL UNIQUE CHECK(
        email_id ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'
    ),
  	age INT NOT NULL CHECK(age > 0),
    mobile_no VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS passenger (
    pid UUID DEFAULT UUID_GENERATE_V4() PRIMARY KEY,
  	name VARCHAR(100) NOT NULL,
    age INT NOT NULL CHECK (age > 0)
);

CREATE TABLE IF NOT EXISTS seat (
    seat_id SERIAL PRIMARY KEY,
    seat_no INT CHECK(seat_no > 0),
    train_no INT NOT NULL,
    seat_type SEAT_TYPE NOT NULL,
    UNIQUE(seat_no, train_no),
    FOREIGN KEY(train_no) REFERENCES train(train_no) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ticket (
    pnr UUID DEFAULT UUID_GENERATE_V4() PRIMARY KEY,
    -- The actual cost for the passenger for its journey
    cost INT NOT NULL CHECK (cost > 0),
    src_station_id INT NOT NULL,
    dest_station_id INT NOT NULL,
    train_no INT NOT NULL,
    user_id INT NOT NULL,
    date DATE NOT NULL CHECK(date - CURRENT_DATE >= 0),
    pid UUID NOT NULL,
  	seat_id INT DEFAULT NULL,
    seat_type SEAT_TYPE DEFAULT NULL,
    booking_status BOOKING_STATUS DEFAULT 'Waiting',
  	booking_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(src_station_id) REFERENCES railway_station(station_id) ON DELETE CASCADE,
    FOREIGN KEY(dest_station_id) REFERENCES railway_station(station_id) ON DELETE CASCADE,
    FOREIGN KEY(train_no) REFERENCES train(train_no) ON DELETE CASCADE,
    FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY(pid) REFERENCES passenger(pid) ON DELETE CASCADE,
  	FOREIGN KEY(seat_id) REFERENCES seat(seat_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS schedule (
    sch_id SERIAL PRIMARY KEY,
    -- Train Number to which the schedule is assigned
    train_no INT NOT NULL,
    -- Station from which the train departs
    curr_station_id INT NOT NULL,
    -- Station to which the train arrives
    -- For the destination station, this value can be NULL
    next_station_id INT,
    -- (Day of Journey, Time) at which the train will arrive at the current station
    arr_time DAY_TIME NOT NULL,
    -- (Day of Journey, Time) at which the train will depart from the current station
    dep_time DAY_TIME NOT NULL CHECK(arr_time <= dep_time),
    -- Fare from the source station of the train till the current_station
    fare NUMERIC(7, 2) NOT NULL CHECK(fare >= 0),
    -- Time by which the train will be delayed at the current station
    delay_time INTERVAL NOT NULL CHECK(delay_time >= INTERVAL '0'),
    FOREIGN KEY(train_no) REFERENCES train(train_no) ON DELETE CASCADE,
    FOREIGN KEY(curr_station_id) REFERENCES railway_station(station_id) ON DELETE CASCADE,
    FOREIGN KEY(next_station_id) REFERENCES railway_station(station_id) ON DELETE CASCADE
);

-- CREATE TABLE IF NOT EXISTS reservation (
--     res_id SERIAL PRIMARY KEY,
--     date DATE NOT NULL,
--     sch_id INT NOT NULL,
--     seat_id INT NOT NULL,
--     pnr UUID,
--     booked BOOLEAN DEFAULT FALSE NOT NULL,
--     FOREIGN KEY(sch_id) REFERENCES schedule(sch_id) ON DELETE CASCADE,
--     FOREIGN KEY(seat_id) REFERENCES seat(seat_id) ON DELETE CASCADE,
--     FOREIGN KEY(pnr) REFERENCES ticket(pnr) ON DELETE CASCADE
-- );


-------------------------------------------------------------------------------------------------------------------------------------------------
-- Aditya
-- passenger, ticket
-------------------------------------------------------------------------------------------------------------------------------------------------
-- Satyam
-- users, train
-------------------------------------------------------------------------------------------------------------------------------------------------
-- Mayank
-- railway_station, schedule, seat, reservation
-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
