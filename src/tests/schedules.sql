-- Schedules for different trains
CALL add_schedule(
    'PJBK'::VARCHAR(100),
    ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]::INT[],
    ARRAY['AC', 'AC', 'AC', 'NON-AC', 'NON-AC', 'NON-AC', 'AC', 'AC', 'AC', 'AC']::SEAT_TYPE[],
    ARRAY['Monday', 'Wednesday', 'Friday']::DAY_OF_WEEK[],
    ARRAY['Palakkad_RS', 'Jaipur_RS', 'Bangalore_RS', 'Kolkata_RS']::VARCHAR(100)[],
    ARRAY[(1, '02:00:00'), (1, '05:00:00'), (1, '07:00:00'), (1, '09:00:00')]::DAY_TIME[],
    ARRAY[(1, '03:00:00'), (1, '05:30:00'), (1, '07:30:00'), (1, '09:20:00')]::DAY_TIME[],
    ARRAY[0, 1000, 4000, 5000]::NUMERIC(7, 2)[]
);

CALL add_schedule(
    'CLBK'::VARCHAR(100),
    ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]::INT[],
    ARRAY['AC', 'AC', 'AC', 'NON-AC', 'NON-AC', 'NON-AC', 'AC', 'AC', 'AC', 'AC']::SEAT_TYPE[],
    ARRAY['Monday', 'Saturday']::DAY_OF_WEEK[],
    ARRAY['Chennai_RS', 'Lucknow_RS', 'Bangalore_RS', 'Kolkata_RS']::VARCHAR(100)[],
    ARRAY[(1, '02:00:00'), (1, '06:00:00'), (1, '07:00:00'), (2, '09:00:00')]::DAY_TIME[],
    ARRAY[(1, '03:00:00'), (1, '06:30:00'), (1, '07:30:00'), (2, '09:20:00')]::DAY_TIME[],
    ARRAY[0, 1000, 4000, 9000]::NUMERIC(7, 2)[]
);

CALL add_schedule(
    'KMD'::VARCHAR(100),
    ARRAY[1, 2, 3, 4, 5, 6]::INT[],
    ARRAY['AC', 'AC', 'NON-AC', 'AC', 'NON-AC', 'NON-AC']::SEAT_TYPE[],
    ARRAY['Monday', 'Thursday']::DAY_OF_WEEK[],
    ARRAY['Kolkata_RS', 'Mumbai_RS', 'Delhi_RS']::VARCHAR(100)[],
    ARRAY[(1, '12:00:00'), (2, '14:00:00'), (3, '16:00:00')]::DAY_TIME[],
    ARRAY[(1, '13:00:00'), (3, '15:00:00'), (3, '17:00:00')]::DAY_TIME[],
    ARRAY[0, 1000, 2000]::NUMERIC(7, 2)[]
);

CALL add_schedule(
    'KCBMD'::VARCHAR(100),
    ARRAY[1, 2, 3, 4]::INT[],
    ARRAY['AC', 'AC', 'NON-AC', 'AC']::SEAT_TYPE[],
    ARRAY['Monday', 'Wednesday', 'Friday']::DAY_OF_WEEK[],
    ARRAY['Kolkata_RS', 'Chennai_RS', 'Bangalore_RS', 'Mumbai_RS', 'Delhi_RS']::VARCHAR(100)[],
    ARRAY[(1, '12:00:00'), (1, '14:00:00'), (1, '16:00:00'), (2, '18:00:00'), (2, '19:50:00')]::DAY_TIME[],
    ARRAY[(1, '13:00:00'), (1, '15:00:00'), (2, '17:00:00'), (2, '19:00:00'), (2, '21:50:00')]::DAY_TIME[],
    ARRAY[0, 100, 200, 300, 400]::NUMERIC(7, 2)[]
);

CALL add_schedule(
    'DGIPK'::VARCHAR(100),
    ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]::INT[],
    ARRAY['AC', 'AC', 'NON-AC', 'AC', 'NON-AC', 'NON-AC', 'AC', 'AC', 'NON-AC', 'AC']::SEAT_TYPE[],
    ARRAY['Monday']::DAY_OF_WEEK[],
    ARRAY['Delhi_RS', 'Gujarat_RS', 'Indore_RS', 'Palakkad_RS', 'Kolkata_RS']::VARCHAR(100)[],
    ARRAY[(1, '2:00:00'), (1, '4:00:00'), (1, '6:00:00'), (3, '12:00:00'), (5, '19:55:00')]::DAY_TIME[],
    ARRAY[(1, '3:00:00'), (1, '5:00:00'), (3, '7:00:00'), (3, '13:00:00'), (5, '20:50:00')]::DAY_TIME[],
    ARRAY[0, 1000, 2000, 3000, 4000]::NUMERIC(7, 2)[]
);

CALL add_schedule(
    'LJMPKD'::VARCHAR(100),
    ARRAY[1, 2, 3, 4, 5, 6, 7, 8]::INT[],
    ARRAY['AC', 'AC', 'NON-AC', 'AC', 'NON-AC', 'NON-AC', 'NON-AC', 'AC']::SEAT_TYPE[],
    ARRAY['Tuesday']::DAY_OF_WEEK[],
    ARRAY['Lucknow_RS', 'Jaipur_RS', 'Mumbai_RS', 'Palakkad_RS', 'Kolkata_RS', 'Delhi_RS']::VARCHAR(100)[],
    ARRAY[(1, '2:00:00'), (1, '4:00:00'), (1, '6:00:00'), (2, '12:00:00'), (3, '19:55:00'), (3, '21:55:00')]::DAY_TIME[],
    ARRAY[(1, '3:00:00'), (1, '5:00:00'), (2, '7:00:00'), (2, '13:00:00'), (3, '20:50:00'), (4, '22:55:00')]::DAY_TIME[],
    ARRAY[0, 1000, 2000, 3000, 4000, 5000]::NUMERIC(7, 2)[]
);

CALL add_schedule(
    'IJBC'::VARCHAR(100),
    ARRAY[1, 2, 3, 4, 5, 6, 7]::INT[],
    ARRAY['AC', 'AC', 'AC', 'NON-AC', 'NON-AC', 'NON-AC', 'AC']::SEAT_TYPE[],
    ARRAY['Monday', 'Tuesday', 'Saturday']::DAY_OF_WEEK[],
    ARRAY['Indore_RS', 'Jaipur_RS', 'Bangalore_RS', 'Chennai_RS']::VARCHAR(100)[],
    ARRAY[(1, '2:00:00'), (1, '4:00:00'), (1, '6:00:00'), (1, '12:00:00')]::DAY_TIME[],
    ARRAY[(1, '3:00:00'), (1, '5:00:00'), (1, '7:00:00'), (1, '13:00:00')]::DAY_TIME[],
    ARRAY[0, 1000, 4000, 5000]::NUMERIC(7, 2)[]
);

CALL add_schedule(
    'LGCP'::VARCHAR(100),
    ARRAY[1, 2]::INT[],
    ARRAY['AC', 'NON-AC']::SEAT_TYPE[],
    ARRAY['Monday']::DAY_OF_WEEK[],
    ARRAY['Lucknow_RS', 'Gujarat_RS', 'Chennai_RS', 'Palakkad_RS']::VARCHAR(100)[],
    ARRAY[(1, '12:00:00'), (1, '14:00:00'), (2, '16:00:00'), (4, '18:00:00')]::DAY_TIME[],
    ARRAY[(1, '13:00:00'), (2, '15:00:00'), (3, '17:00:00'), (4, '19:00:00')]::DAY_TIME[],
    ARRAY[0, 1020, 4300, 5050]::NUMERIC(7, 2)[]
);

CALL add_schedule(
    'BCDGIJKLMP'::VARCHAR(100),
    ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]::INT[],
    ARRAY['AC', 'AC', 'NON-AC', 'AC', 'NON-AC', 'NON-AC', 'AC', 'AC', 'NON-AC', 'AC', 'NON-AC', 'NON-AC', 'AC', 'AC', 'NON-AC', 'AC', 'NON-AC', 'NON-AC', 'AC', 'AC', 'NON-AC', 'AC', 'NON-AC', 'NON-AC']::SEAT_TYPE[],
    ARRAY['Sunday']::DAY_OF_WEEK[],
    ARRAY['Bangalore_RS', 'Chennai_RS', 'Delhi_RS', 'Gujarat_RS', 'Indore_RS', 'Jaipur_RS', 'Kolkata_RS', 'Lucknow_RS', 'Mumbai_RS', 'Palakkad_RS']::VARCHAR(100)[],
    ARRAY[(1, '09:00:00'), (1, '12:00:00'), (2, '01:00:00'), (2, '10:00:00'), (2, '13:00:00'), (3, '11:00:00'), (5, '01:10:00'), (5, '12:50:00'), (6, '05:00:00'), (7, '09:00:00')]::DAY_TIME[],
    ARRAY[(1, '10:00:00'), (1, '16:00:00'), (2, '04:00:00'), (2, '10:30:00'), (3, '07:30:00'), (3, '12:00:00'), (5, '03:00:00'), (5, '15:00:00'), (7, '05:00:00'), (7, '18:00:00')]::DAY_TIME[],
    ARRAY[0, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000]::NUMERIC(7, 2)[]
);
