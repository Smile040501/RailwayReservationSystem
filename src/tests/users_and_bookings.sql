-- Users
CALL add_user('abc', 'abc@abc.com', 18, '9888887777');
CALL add_user('def', 'def@def.com', 25, '9777766555');
CALL add_user('ghi', 'ghi@ghi.com', 40, '9999999999');
CALL add_user('jkl', 'jkl@jkl.com', 31, '9876543210');
CALL add_user('mno', 'mno@mno.com', 55, '9988776655');


-- Bookings

-- TC-1
-- pqr will in waiting
CALL book_tickets(
    ARRAY['ghi', 'jkl', 'mno', 'pqr']::VARCHAR(100)[],
    ARRAY[13, 15, 17, 19]::INT[],
    ARRAY['NON-AC', 'NON-AC', 'NON-AC', 'NON-AC']::SEAT_TYPE[],
    'Indore_RS',
    'Bangalore_RS',
    'IJBC',
    '2022-05-09'::DATE,
    'abc@abc.com'
);

-- TC-2
-- same seat as nanu
CALL book_tickets(
    ARRAY['yogita']::VARCHAR(100)[],
    ARRAY[35]::INT[],
    ARRAY['NON-AC']::SEAT_TYPE[],
    'Kolkata_RS',
    'Bangalore_RS',
    'KCBMD',
    '2022-05-09'::DATE,
    'ghi@ghi.com'
);
-- same seat as yogita
CALL book_tickets(
    ARRAY['nanu']::VARCHAR(100)[],
    ARRAY[30]::INT[],
    ARRAY['NON-AC']::SEAT_TYPE[],
    'Bangalore_RS',
    'Delhi_RS',
    'KCBMD',
    '2022-05-09'::DATE,
    'ghi@ghi.com'
);

-- this will be in waiting
CALL book_tickets(
    ARRAY['titu']::VARCHAR(100)[],
    ARRAY[31]::INT[],
    ARRAY['NON-AC']::SEAT_TYPE[],
    'Chennai_RS',
    'Delhi_RS',
    'KCBMD',
    '2022-05-09'::DATE,
    'mno@mno.com'
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
    '2022-05-10'::DATE,
    'mno@mno.com'
);

-- TC-4
CALL book_tickets(  -- Will get seat booked
    ARRAY['zyx']::VARCHAR(100)[],
    ARRAY[13]::INT[],
    ARRAY['AC']::SEAT_TYPE[],
    'Lucknow_RS'::VARCHAR(100),
    'Chennai_RS'::VARCHAR(100),
    'LGCP'::VARCHAR(100),
    '2022-05-09'::DATE,
    'abc@abc.com'::VARCHAR(100)
);

CALL book_tickets(  -- Will get seat booked
    ARRAY['wvu']::VARCHAR(100)[],
    ARRAY[29]::INT[],
    ARRAY['AC']::SEAT_TYPE[],
    'Gujarat_RS'::VARCHAR(100),
    'Palakkad_RS'::VARCHAR(100),
    'LGCP'::VARCHAR(100),
    '2022-05-09'::DATE,
    'mno@mno.com'::VARCHAR(100)
);

CALL book_tickets(  -- `lkj` not get seat booked
    ARRAY['lkj', 'gfe']::VARCHAR(100)[],
    ARRAY[37, 55]::INT[],
    ARRAY['AC', 'NON-AC']::SEAT_TYPE[],
    'Gujarat_RS'::VARCHAR(100),
    'Chennai_RS'::VARCHAR(100),
    'LGCP'::VARCHAR(100),
    '2022-05-09'::DATE,
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
    '2022-05-16'::DATE,
    'abc@abc.com'::VARCHAR(100)
);

CALL book_tickets(  -- Will get seat booked
    ARRAY['rqp']::VARCHAR(100)[],
    ARRAY[29]::INT[],
    ARRAY['AC']::SEAT_TYPE[],
    'Chennai_RS'::VARCHAR(100),
    'Palakkad_RS'::VARCHAR(100),
    'LGCP'::VARCHAR(100),
    '2022-05-17'::DATE,
    'mno@mno.com'::VARCHAR(100)
);

CALL book_tickets(  -- Will get seat booked
    ARRAY['lkj', 'gfe']::VARCHAR(100)[],
    ARRAY[37, 55]::INT[],
    ARRAY['AC', 'NON-AC']::SEAT_TYPE[],
    'Gujarat_RS'::VARCHAR(100),
    'Chennai_RS'::VARCHAR(100),
    'LGCP'::VARCHAR(100),
    '2022-05-16'::DATE,
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
    '2022-05-26'::DATE,
    'abc@abc.com'::VARCHAR(100)
);

CALL book_tickets(  -- Will not get seat booked
    ARRAY['def']::VARCHAR(100)[],
    ARRAY[55]::INT[],
    ARRAY['AC']::SEAT_TYPE[],
    'Gujarat_RS'::VARCHAR(100),
    'Jaipur_RS'::VARCHAR(100),
    'GIJK'::VARCHAR(100),
    '2022-05-26'::DATE,
    'def@def.com'::VARCHAR(100)
);

CALL book_tickets(  -- Will not get seat booked
    ARRAY['ghi']::VARCHAR(100)[],
    ARRAY[61]::INT[],
    ARRAY['AC']::SEAT_TYPE[],
    'Jaipur_RS',
    'Kolkata_RS',
    'GIJK',
    '2022-05-27'::DATE,
    'ghi@ghi.com'
);
