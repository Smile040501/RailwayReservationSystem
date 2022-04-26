-- Users
CALL add_user('abc', 'abc@abc.com', 18, '9888887777');
CALL add_user('def', 'def@def.com', 25, '9777766555');
CALL add_user('ghi', 'ghi@ghi.com', 40, '9999999999');
CALL add_user('jkl', 'jkl@jkl.com', 31, '9876543210');
CALL add_user('mno', 'mno@mno.com', 55, '9988776655');


-- Bookings

-- TC-4
CALL book_tickets(  -- Will get seat booked
    ARRAY['zyx']::VARCHAR(100)[],
    ARRAY[13]::INT[],
    ARRAY['AC']::SEAT_TYPE[],
    'Lucknow_RS'::VARCHAR(100),
    'Chennai_RS'::VARCHAR(100),
    'LGCP'::VARCHAR(100),
    '2022-04-25'::DATE,
    'abc@abc.com'::VARCHAR(100)
);

CALL book_tickets(  -- Will get seat booked
    ARRAY['wvu']::VARCHAR(100)[],
    ARRAY[29]::INT[],
    ARRAY['AC']::SEAT_TYPE[],
    'Gujarat_RS'::VARCHAR(100),
    'Palakkad_RS'::VARCHAR(100),
    'LGCP'::VARCHAR(100),
    '2022-04-25'::DATE,
    'mno@mno.com'::VARCHAR(100)
);

CALL book_tickets(  -- `gfe` not get seat booked
    ARRAY['lkj', 'gfe']::VARCHAR(100)[],
    ARRAY[37, 55]::INT[],
    ARRAY['AC', 'NON-AC']::SEAT_TYPE[],
    'Gujarat_RS'::VARCHAR(100),
    'Chennai_RS'::VARCHAR(100),
    'LGCP'::VARCHAR(100),
    '2022-04-25'::DATE,
    'def@def.com'::VARCHAR(100)
);


-- TC-5
CALL book_tickets(  -- Will get seat booked
    ARRAY['cba']::VARCHAR(100)[],
    ARRAY[13]::INT[],
    ARRAY['AC']::SEAT_TYPE[],
    'Lucknow_RS'::VARCHAR(100),
    'Gujarat_RS'::VARCHAR(100),
    'LGCP'::VARCHAR(100),
    '2022-04-18'::DATE,
    'abc@abc.com'::VARCHAR(100)
);

CALL book_tickets(  -- Will get seat booked
    ARRAY['rqp']::VARCHAR(100)[],
    ARRAY[29]::INT[],
    ARRAY['AC']::SEAT_TYPE[],
    'Chennai_RS'::VARCHAR(100),
    'Palakkad_RS'::VARCHAR(100),
    'LGCP'::VARCHAR(100),
    '2022-04-19'::DATE,
    'mno@mno.com'::VARCHAR(100)
);

CALL book_tickets(  -- Will get seat booked
    ARRAY['lkj', 'gfe']::VARCHAR(100)[],
    ARRAY[37, 55]::INT[],
    ARRAY['AC', 'NON-AC']::SEAT_TYPE[],
    'Gujarat_RS'::VARCHAR(100),
    'Chennai_RS'::VARCHAR(100),
    'LGCP'::VARCHAR(100),
    '2022-04-18'::DATE,
    'def@def.com'::VARCHAR(100)
);


-- TC-6
CALL book_tickets(  -- Will get seat booked
    ARRAY['abc']::VARCHAR(100)[],
    ARRAY[37]::INT[],
    ARRAY['AC']::SEAT_TYPE[],
    'Indore_RS'::VARCHAR(100),
    'Kolkata_RS'::VARCHAR(100),
    'GIJK'::VARCHAR(100),
    '2022-04-28'::DATE,
    'abc@abc.com'::VARCHAR(100)
);

CALL book_tickets(  -- Will not get seat booked
    ARRAY['def']::VARCHAR(100)[],
    ARRAY[55]::INT[],
    ARRAY['AC']::SEAT_TYPE[],
    'Gujarat_RS'::VARCHAR(100),
    'Jaipur_RS'::VARCHAR(100),
    'GIJK'::VARCHAR(100),
    '2022-04-28'::DATE,
    'def@def.com'::VARCHAR(100)
);

CALL book_tickets(  -- Will not get seat booked
    ARRAY['ghi']::VARCHAR(100)[],
    ARRAY[61]::INT[],
    ARRAY['AC']::SEAT_TYPE[],
    'Jaipur_RS',
    'Kolkata_RS',
    'GIJK',
    '2022-04-29'::DATE,
    'ghi@ghi.com'
);
