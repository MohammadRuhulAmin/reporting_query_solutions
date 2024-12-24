#Set Environment variable checking:

SET GLOBAL event_scheduler = ON;

# Check the variable:

SHOW VARIABLES LIKE 'event_scheduler';

# Create an Event Scheduler:

CREATE EVENT insert_if_time_reached
ON SCHEDULE EVERY 1 MINUTE
DO
BEGIN
  IF EXISTS (
    SELECT 1
    FROM timed_inserts
    WHERE NOW() >= last_updated
  ) THEN
    INSERT INTO timed_inserts (data, last_updated)
    VALUES ('New Timed Entry', NOW() + INTERVAL 1 MINUTE);
  END IF;
END;

# See the Events:
SHOW EVENTS;

# Drop an Events:
DROP EVENT increment_counter;

