-- User Defined Types
CREATE TYPE DAY_OF_WEEK AS ENUM (
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
);

CREATE TYPE SEAT_TYPE AS ENUM ('AC', 'NON-AC');

CREATE TYPE BOOKING_STATUS AS ENUM('Waiting', 'Booked', 'Cancelled');

CREATE TYPE DAY_TIME AS (
    day_of_journey INT,  -- Max value is 7
    time TIME
);

-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "intarray";
