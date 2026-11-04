-- View: one row per web session, for the funnel (Q12) and Power BI.
-- Each has_ column is 1 if the session had this event at least once, otherwise 0.
-- session_date is the local date (Vilnius time) when the session started.
DROP VIEW IF EXISTS analytics.session_funnel;
CREATE VIEW analytics.session_funnel AS
SELECT
    session_id,
    (MIN(event_ts) AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Vilnius')::date AS session_date,
    MAX(device) AS device,
    MAX(traffic_source) AS traffic_source,
    MAX(CASE WHEN event_type = 'view_item' THEN 1 ELSE 0 END) AS has_view,
    MAX(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS has_cart,
    MAX(CASE WHEN event_type = 'begin_checkout' THEN 1 ELSE 0 END) AS has_checkout,
    MAX(CASE WHEN event_type = 'add_payment_info' THEN 1 ELSE 0 END) AS has_payment,
    MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS has_purchase
FROM clean.user_events
GROUP BY session_id;