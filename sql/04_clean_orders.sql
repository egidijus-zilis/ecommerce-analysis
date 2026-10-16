DROP TABLE IF EXISTS clean.orders;

CREATE TABLE clean.orders AS
SELECT DISTINCT                -- DQ-09
    order_id,
    customer_id,
    session_id,
    order_ts,
    status,
    coupon_code,
    payment_method,
    delivery_method,
    shipping_fee,
    order_total,
    promised_date,
    CASE
        WHEN (order_ts AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Vilnius')::date > delivered_date THEN NULL
        ELSE delivered_date
    END AS delivered_date      -- DQ-18
FROM raw.orders
WHERE customer_id <> 1;        -- DQ-01, DQ-10


-- checks: raw

SELECT *
FROM raw.orders
WHERE order_total < 1;

SELECT *
FROM raw.orders
WHERE customer_id = 1;

SELECT *
FROM raw.customers
WHERE customer_id = 1;

SELECT order_id, COUNT(*)
FROM raw.orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT COUNT(*)
FROM raw.orders;

SELECT COUNT(*)
FROM (
    SELECT DISTINCT *
    FROM raw.orders
) AS t;

SELECT *
FROM raw.orders
WHERE (order_ts AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Vilnius')::date > delivered_date;


-- checks: clean

SELECT COUNT(*)
FROM clean.orders;

SELECT order_id, COUNT(*)
FROM clean.orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT *
FROM clean.orders
WHERE customer_id = 1;

SELECT *
FROM clean.orders
WHERE (order_ts AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Vilnius')::date > delivered_date;