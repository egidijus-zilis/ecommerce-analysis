-- Q6. Do customers buy again?
-- Data: analytics.orders_enriched, completed orders only.
-- A customer is one person (main_customer_id).


-- Part 1. What share of customers buy again?

-- 1a. All customers
WITH customer_order_count AS (
SELECT
    main_customer_id,
    COUNT(*) AS orders
FROM analytics.orders_enriched
WHERE order_status = 'completed'
GROUP BY main_customer_id)
SELECT
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE orders > 1) AS returning_customers,
    ROUND(COUNT(*) FILTER (WHERE orders > 1)::numeric / COUNT(*) * 100, 2) AS returning_share
FROM customer_order_count;

-- 1b. Back within 90 days (first order before 2026-07-01, so everyone had 90 days)
WITH customer_orders AS (
SELECT
    main_customer_id,
    order_date_local,
    ROW_NUMBER() OVER (PARTITION BY main_customer_id ORDER BY order_ts) AS order_number
FROM analytics.orders_enriched
WHERE order_status = 'completed'),
customer_first_two_orders AS (
SELECT
    main_customer_id,
    MAX(order_date_local) FILTER (WHERE order_number = 1) AS first_order,
    MAX(order_date_local) FILTER (WHERE order_number = 2) AS second_order
FROM customer_orders
GROUP BY main_customer_id),
returning_time AS (
SELECT
    main_customer_id,
    first_order,
    second_order,
    second_order - first_order AS days_to_second_order
FROM customer_first_two_orders)
SELECT
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE days_to_second_order <= 90) AS returned_in_90_days,
    ROUND(COUNT(*) FILTER (WHERE days_to_second_order <= 90)::numeric / COUNT(*) * 100, 2) AS share_in_90_days
FROM returning_time
WHERE first_order < DATE '2026-07-01';


-- Part 2. How soon do they buy again?

-- 2a. Days from the first to the second order (only customers who bought again)
WITH customer_orders AS (
SELECT
    main_customer_id,
    order_date_local,
    ROW_NUMBER() OVER (PARTITION BY main_customer_id ORDER BY order_ts) AS order_number
FROM analytics.orders_enriched
WHERE order_status = 'completed'),
customer_first_two_orders AS (
SELECT
    main_customer_id,
    MAX(order_date_local) FILTER (WHERE order_number = 1) AS first_order,
    MAX(order_date_local) FILTER (WHERE order_number = 2) AS second_order
FROM customer_orders
GROUP BY main_customer_id),
returning_time AS (
SELECT
    main_customer_id,
    first_order,
    second_order,
    second_order - first_order AS days_to_second_order
FROM customer_first_two_orders)
SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY days_to_second_order) AS median_days,
    ROUND(AVG(days_to_second_order), 2) AS average_days,
    ROUND(COUNT(*) FILTER (WHERE days_to_second_order <= 90)::numeric / COUNT(*) * 100, 2) AS share_in_90_days,
    ROUND(COUNT(*) FILTER (WHERE days_to_second_order <= 180)::numeric / COUNT(*) * 100, 2) AS share_in_180_days
FROM returning_time
WHERE days_to_second_order IS NOT NULL;


-- Part 3. Do newer cohorts come back more or less than older ones?

-- 3a. Back within 90 days, by quarterly cohort
WITH customer_orders AS (
SELECT
    main_customer_id,
    order_date_local,
    ROW_NUMBER() OVER (PARTITION BY main_customer_id ORDER BY order_ts) AS order_number
FROM analytics.orders_enriched
WHERE order_status = 'completed'),
customer_first_two_orders AS (
SELECT
    main_customer_id,
    MAX(order_date_local) FILTER (WHERE order_number = 1) AS first_order,
    MAX(order_date_local) FILTER (WHERE order_number = 2) AS second_order
FROM customer_orders
GROUP BY main_customer_id),
returning_time AS (
SELECT
    main_customer_id,
    first_order,
    second_order,
    second_order - first_order AS days_to_second_order
FROM customer_first_two_orders)
SELECT
    DATE_TRUNC('quarter', first_order)::date AS cohort,
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE days_to_second_order <= 90) AS returned_in_90_days,
    ROUND(COUNT(*) FILTER (WHERE days_to_second_order <= 90)::numeric / COUNT(*) * 100, 2) AS share_in_90_days
FROM returning_time
WHERE first_order < DATE '2026-07-01'
GROUP BY cohort
ORDER BY cohort;
