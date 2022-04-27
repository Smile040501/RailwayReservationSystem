ALTER TABLE users
ENABLE ROW LEVEL SECURITY;

CREATE POLICY users_policy
ON users
FOR ALL
TO users
USING (username = CURRENT_USER);

ALTER TABLE ticket
ENABLE ROW LEVEL SECURITY;

CREATE POLICY ticket_policy
ON ticket
FOR SELECT
TO users
USING (ticket.user_id = (SELECT user_id
                            FROM users
                            WHERE username = CURRENT_USER
                        )
    );


ALTER TABLE passenger
ENABLE ROW LEVEL SECURITY;

CREATE POLICY passenger_policy
ON passenger
FOR ALL
TO users
USING (passenger.pid = ANY(SELECT pid
                            FROM ticket
                            WHERE ticket.user_id = (SELECT user_id
                                                    FROM users
                                                    WHERE username = CURRENT_USER
                                                    )
                        )
    );
