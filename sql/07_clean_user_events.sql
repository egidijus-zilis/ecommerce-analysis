DROP TABLE IF EXISTS clean.user_events;

CREATE TABLE clean.user_events AS
SELECT
    event_id,
    session_id,
    visitor_id,
    customer_id,
    event_type,
    event_ts,
    device,
    COALESCE(traffic_source, 'unknown') AS traffic_source,   -- DQ-14
    product_id
FROM raw.user_events
WHERE visitor_id <> 4410023875                       -- DQ-19
  AND (customer_id IS NULL OR customer_id <> 1)      -- DQ-01
  AND event_id NOT IN (                              -- DQ-15
      SELECT MAX(event_id)
      FROM raw.user_events
      WHERE event_type = 'purchase'
      GROUP BY session_id
      HAVING COUNT(*) > 1
  );


-- checks: raw

SELECT session_id, COUNT(*)
FROM raw.user_events
WHERE event_type = 'purchase'
GROUP BY session_id
HAVING COUNT(*) > 1;

WITH dup AS (
    SELECT *
    FROM raw.user_events
    WHERE event_type = 'purchase'
      AND session_id IN (
          SELECT session_id
          FROM raw.user_events
          WHERE event_type = 'purchase'
          GROUP BY session_id
          HAVING COUNT(*) > 1)
)
SELECT COUNT(*)
FROM (
    SELECT DISTINCT session_id, visitor_id, customer_id, event_type, event_ts, device, traffic_source, product_id
    FROM dup
) AS t;

SELECT COUNT(*)
FROM raw.user_events
WHERE visitor_id = 4410023875;


-- checks: clean

SELECT COUNT(*)
FROM clean.user_events;

SELECT session_id, COUNT(*)
FROM clean.user_events
WHERE event_type = 'purchase'
GROUP BY session_id
HAVING COUNT(*) > 1;

SELECT COUNT(*)
FROM clean.user_events
WHERE visitor_id = 4410023875 OR customer_id = 1 OR traffic_source IS NULL;