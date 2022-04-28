-- Displays schedule of all the trains at all the stations
CREATE VIEW stations_trains AS
SELECT sch.train_no,
    sch.curr_station_id,
    sch.next_station_id,
    tt.name AS train_name,
    pretty_station_name(src.name, src.city, src.state) AS source_station,
    pretty_station_name(curr.name, curr.city, curr.state) AS current_station,
    pretty_station_name(nxt.name, nxt.city, nxt.state) AS next_station,
    pretty_station_name(dest.name, dest.city, dest.state) AS destination_station,
    (sch.arr_time).time AS arrival_time,
    (sch.dep_time).time AS departure_time,
    '{' || ARRAY_TO_STRING(get_updated_days(
                    (sch.arr_time).day_of_journey,
                    tt.week_days
            ), ',', '')
        || '}' AS arrival_days,
    '{' || ARRAY_TO_STRING(get_updated_days(
                    (sch.dep_time).day_of_journey,
                    tt.week_days), ',', '')
        || '}' AS departure_days,
    sch.delay_time,
    tt.total_seats,
    tt.week_days
FROM schedule AS sch
    JOIN train AS tt ON sch.train_no = tt.train_no
    JOIN railway_station AS src ON tt.src_station_id = src.station_id
    JOIN railway_station AS curr ON sch.curr_station_id = curr.station_id
    LEFT JOIN railway_station AS nxt ON sch.next_station_id = nxt.station_id
    JOIN railway_station AS dest ON tt.dest_station_id = dest.station_id
ORDER BY sch.train_no ASC, sch.arr_time ASC;
