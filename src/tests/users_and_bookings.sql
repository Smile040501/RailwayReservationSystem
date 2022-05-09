-- Users
CALL add_user(
    in_name     => 'abc',
    in_email    => 'abc@abc.com',
    in_password => 'abc',
    in_age      => 18,
    in_mobile   => '9888887777'
);

CALL add_user('def', 'def@def.com', 'def', 25, '9777766555');
CALL add_user('ghi', 'ghi@ghi.com', 'ghi', 40, '9999999999');
CALL add_user('jkl', 'jkl@jkl.com', 'jkl', 31, '9876543210');
CALL add_user('mno', 'mno@mno.com', 'mno', 55, '9988776655');


-- Bookings

-- TC-1
-- pqr will in waiting

\c railway_reservation_system abc@abc.com

CALL book_tickets(
    in_name      => ARRAY['ghi', 'jkl', 'mno', 'pqr']::VARCHAR(100)[],
    in_age       => ARRAY[13, 15, 17, 19]::INT[],
    in_seat_type => ARRAY['NON-AC', 'NON-AC', 'NON-AC', 'NON-AC']::SEAT_TYPE[],
    src_station  => 'Indore_RS',
    dest_station => 'Bangalore_RS',
    train_name   => 'IJBC',
    in_date      => '2022-05-09'::DATE
);

-- TC-2
-- same seat as nanu
\c railway_reservation_system ghi@ghi.com
CALL book_tickets(
    ARRAY['yogita']::VARCHAR(100)[],
    ARRAY[35]::INT[],
    ARRAY['NON-AC']::SEAT_TYPE[],
    'Kolkata_RS',
    'Bangalore_RS',
    'KCBMD',
    '2022-05-09'::DATE
);
-- same seat as yogita
CALL book_tickets(
    ARRAY['nanu']::VARCHAR(100)[],
    ARRAY[30]::INT[],
    ARRAY['NON-AC']::SEAT_TYPE[],
    'Bangalore_RS',
    'Delhi_RS',
    'KCBMD',
    '2022-05-09'::DATE
);

-- this will be in waiting
\c railway_reservation_system mno@mno.com
CALL book_tickets(
    ARRAY['titu']::VARCHAR(100)[],
    ARRAY[31]::INT[],
    ARRAY['NON-AC']::SEAT_TYPE[],
    'Chennai_RS',
    'Delhi_RS',
    'KCBMD',
    '2022-05-09'::DATE
);

-- TC-3
-- u5 will be in waiting
CALL book_tickets(
    ARRAY['u1', 'u2', 'u3', 'u4', 'u5']::VARCHAR(100)[],
    ARRAY[27, 29, 31, 25, 15]::INT[],
    ARRAY['AC','NON-AC','NON-AC','NON-AC','NON-AC']::SEAT_TYPE[],
    'Mumbai_RS',
    'Delhi_RS',
    'KMD',
    '2022-05-10'::DATE
);

-- TC-4
\c railway_reservation_system abc@abc.com
CALL book_tickets(  -- Will get seat booked
    ARRAY['zyx']::VARCHAR(100)[],
    ARRAY[13]::INT[],
    ARRAY['AC']::SEAT_TYPE[],
    'Lucknow_RS'::VARCHAR(100),
    'Chennai_RS'::VARCHAR(100),
    'LGCP'::VARCHAR(100),
    '2022-05-09'::DATE
);

\c railway_reservation_system mno@mno.com
CALL book_tickets(  -- Will get seat booked
    ARRAY['wvu']::VARCHAR(100)[],
    ARRAY[29]::INT[],
    ARRAY['AC']::SEAT_TYPE[],
    'Gujarat_RS'::VARCHAR(100),
    'Palakkad_RS'::VARCHAR(100),
    'LGCP'::VARCHAR(100),
    '2022-05-09'::DATE
);

\c railway_reservation_system def@def.com
CALL book_tickets(  -- `lkj` not get seat booked
    ARRAY['lkj', 'gfe']::VARCHAR(100)[],
    ARRAY[37, 55]::INT[],
    ARRAY['AC', 'NON-AC']::SEAT_TYPE[],
    'Gujarat_RS'::VARCHAR(100),
    'Chennai_RS'::VARCHAR(100),
    'LGCP'::VARCHAR(100),
    '2022-05-09'::DATE
);


-- TC-5
\c railway_reservation_system abc@abc.com
CALL book_tickets(  -- Will get seat booked
    ARRAY['cba']::VARCHAR(100)[],
    ARRAY[13]::INT[],
    ARRAY['AC']::SEAT_TYPE[],
    'Lucknow_RS'::VARCHAR(100),
    'Gujarat_RS'::VARCHAR(100),
    'LGCP'::VARCHAR(100),
    '2022-05-16'::DATE
);

\c railway_reservation_system mno@mno.com
CALL book_tickets(  -- Will get seat booked
    ARRAY['rqp']::VARCHAR(100)[],
    ARRAY[29]::INT[],
    ARRAY['AC']::SEAT_TYPE[],
    'Chennai_RS'::VARCHAR(100),
    'Palakkad_RS'::VARCHAR(100),
    'LGCP'::VARCHAR(100),
    '2022-05-17'::DATE
);

\c railway_reservation_system def@def.com
CALL book_tickets(  -- Will get seat booked
    ARRAY['lkj', 'gfe']::VARCHAR(100)[],
    ARRAY[37, 55]::INT[],
    ARRAY['AC', 'NON-AC']::SEAT_TYPE[],
    'Gujarat_RS'::VARCHAR(100),
    'Chennai_RS'::VARCHAR(100),
    'LGCP'::VARCHAR(100),
    '2022-05-16'::DATE
);


-- TC-6
\c railway_reservation_system abc@abc.com
CALL book_tickets(  -- Will get seat booked
    ARRAY['abc']::VARCHAR(100)[],
    ARRAY[37]::INT[],
    ARRAY['AC']::SEAT_TYPE[],
    'Indore_RS'::VARCHAR(100),
    'Kolkata_RS'::VARCHAR(100),
    'GIJK'::VARCHAR(100),
    '2022-05-26'::DATE
);

\c railway_reservation_system def@def.com
CALL book_tickets(  -- Will not get seat booked
    ARRAY['def']::VARCHAR(100)[],
    ARRAY[55]::INT[],
    ARRAY['AC']::SEAT_TYPE[],
    'Gujarat_RS'::VARCHAR(100),
    'Jaipur_RS'::VARCHAR(100),
    'GIJK'::VARCHAR(100),
    '2022-05-26'::DATE
);

\c railway_reservation_system ghi@ghi.com
CALL book_tickets(  -- Will not get seat booked
    ARRAY['ghi']::VARCHAR(100)[],
    ARRAY[61]::INT[],
    ARRAY['AC']::SEAT_TYPE[],
    'Jaipur_RS',
    'Kolkata_RS',
    'GIJK',
    '2022-05-27'::DATE
);
