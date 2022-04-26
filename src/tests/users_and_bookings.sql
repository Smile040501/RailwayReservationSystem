-- Users
CALL add_user('abc', 'abc@abc.com', 18, '9888887777');
CALL add_user('def', 'def@def.com', 25, '9777766555');
CALL add_user('ghi', 'ghi@ghi.com', 40, '9999999999');
CALL add_user('jkl', 'jkl@jkl.com', 31, '9876543210');
CALL add_user('mno', 'mno@mno.com', 55, '9988776655');


-- Bookings
CALL book_tickets(
    ARRAY['ghi', 'jkl', 'mno', 'pqr']::VARCHAR(100)[],
    ARRAY[13, 15, 17, 19]::INT[],
    ARRAY[UUID_GENERATE_V4(), UUID_GENERATE_V4(), UUID_GENERATE_V4(), UUID_GENERATE_V4()]::UUID[],
    'Kolkata_RS',
    'Delhi_RS',
    'KMD',
    '2022-03-23'::DATE,
    'abc@abc.com'
);

CALL book_tickets(
    ARRAY['stu', 'vwx', 'yz']::VARCHAR(100)[],
    ARRAY[27, 29, 31]::INT[],
    ARRAY[UUID_GENERATE_V4(), UUID_GENERATE_V4(), UUID_GENERATE_V4()]::UUID[],
    'Jaipur_RS',
    'Kolkata_RS',
    'LJMPKD',
    '2022-03-22'::DATE,
    'def@def.com'
);

CALL book_tickets(
    ARRAY['adi', 'manku', 'sattu']::VARCHAR(100)[],
    ARRAY[14, 30, 69]::INT[],
    ARRAY[UUID_GENERATE_V4(), UUID_GENERATE_V4(), UUID_GENERATE_V4()]::UUID[],
    'Chennai_RS',
    'Kolkata_RS',
    'CLBK',
    '2022-03-22'::DATE,
    'def@def.com'
);

CALL book_tickets(
    ARRAY['titu', 'manu', 'chintu']::VARCHAR(100)[],
    ARRAY[27, 29, 31]::INT[],
    ARRAY[UUID_GENERATE_V4(), UUID_GENERATE_V4(), UUID_GENERATE_V4()]::UUID[],
    'Bangalore_RS',
    'Delhi_RS',
    'KCBMD',
    '2022-03-22'::DATE,
    'def@def.com'
);