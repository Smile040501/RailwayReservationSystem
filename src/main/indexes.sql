-- Query 3

CREATE INDEX seat_train_no ON seat USING HASH(train_no);


CREATE INDEX ticket_src_station_id ON ticket USING HASH(src_station_id);
CREATE INDEX ticket_dest_station_id ON ticket USING HASH(dest_station_id);
CREATE INDEX ticket_train_no ON ticket USING HASH(train_no);
CREATE INDEX ticket_user_id ON ticket USING HASH(user_id);
CREATE INDEX ticket_pid ON ticket USING HASH(pid);
CREATE INDEX ticket_seat_id ON ticket USING HASH(seat_id);
CREATE INDEX ticket_date ON ticket USING BTREE(date);
CREATE INDEX ticket_booking_status ON ticket USING HASH(booking_status);
CREATE INDEX ticket_seat_type ON ticket USING HASH(seat_type);


CREATE INDEX train_src_station_id ON train USING HASH(src_station_id);
CREATE INDEX train_dest_station_id ON train USING HASH(dest_station_id);


CREATE INDEX schedule_train_no ON schedule USING HASH(train_no);
CREATE INDEX schedule_curr_station_id ON schedule USING HASH(curr_station_id);
CREATE INDEX schedule_next_station_id ON schedule USING HASH(next_station_id);
