-- Q4. Are discounts worth it?
-- Data: analytics.orders_discount (see sql/13_analytics_orders_discount.sql), completed orders only.


-- Part 1. What do discounts cost?

-- 1a. Money given as discount and margin by order type
SELECT
    what_discount,
    COUNT(*) AS orders,
    SUM(discount_eur) AS lost_to_discount,
    ROUND(SUM(net_revenue), 2) AS net_revenue,
    ROUND(SUM(gross_profit), 2) AS gross_profit,
    ROUND(SUM(gross_profit) / SUM(net_revenue) * 100, 2) AS gross_margin
FROM analytics.orders_discount
GROUP BY what_discount;

-- 1b. Margin if we add the discount back
SELECT
    what_discount,
    ROUND((SUM(gross_profit) + SUM(discount_eur)) / (SUM(net_revenue) + SUM(discount_eur)) * 100, 2) AS margin_without_discount
FROM analytics.orders_discount
GROUP BY what_discount;


-- Part 2. Do discounts bring more orders?

-- 2a. Sale share by month (to find sale periods)
SELECT
    DATE_TRUNC('month', order_date_local)::date AS month,
    COUNT(*) AS all_orders,
    COUNT(*) FILTER (WHERE what_discount = 'sale') AS sale_orders,
    ROUND(COUNT(*) FILTER (WHERE what_discount = 'sale')::numeric / COUNT(*) * 100, 2) AS sale_share
FROM analytics.orders_discount
GROUP BY 1
ORDER BY 1;

-- 2b. Sale share by day around the July 2025 sale
SELECT
    order_date_local,
    COUNT(*) AS all_orders,
    COUNT(*) FILTER (WHERE what_discount = 'sale') AS sale_orders,
    ROUND(COUNT(*) FILTER (WHERE what_discount = 'sale')::numeric / COUNT(*) * 100, 2) AS sale_share
FROM analytics.orders_discount
WHERE order_date_local BETWEEN DATE '2025-06-30' AND DATE '2025-08-20'
GROUP BY order_date_local
ORDER BY 1;

-- 2c. July sale vs June and August (2025 and 2026)
SELECT
    TO_CHAR(order_date_local, 'YYYY-MM') AS year_month,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(COUNT(DISTINCT order_id) / MAX(EXTRACT(DAY FROM order_date_local)), 2) AS orders_per_day,
    SUM(net_revenue) AS net_revenue,
    ROUND(SUM(net_revenue) / COUNT(DISTINCT order_id), 2) AS aov,
    ROUND(SUM(net_revenue) / MAX(EXTRACT(DAY FROM order_date_local)), 2) AS revenue_per_day,
    ROUND(SUM(gross_profit), 2) AS gross_profit,
    ROUND(SUM(gross_profit) / SUM(net_revenue) * 100.0, 2) AS gross_margin
FROM analytics.orders_discount
WHERE TO_CHAR(order_date_local, 'YYYY-MM') IN ('2025-06', '2025-07', '2025-08', '2026-06', '2026-07', '2026-08')
GROUP BY year_month
ORDER BY year_month;


-- Part 3. Do discounts bring new customers?

-- 3a. New customers per day: July sale vs June and August
SELECT
    TO_CHAR(order_date_local, 'YYYY-MM') AS year_month,
    ROUND(SUM(is_first_order) / MAX(EXTRACT(DAY FROM order_date_local)), 2) AS new_customers_per_day
FROM analytics.orders_discount
WHERE TO_CHAR(order_date_local, 'YYYY-MM') IN ('2025-06', '2025-07', '2025-08', '2026-06', '2026-07', '2026-08')
GROUP BY year_month
ORDER BY year_month;

-- 3b. Share of first orders by order type
SELECT
    what_discount,
    COUNT(*) AS orders,
    COUNT(*) FILTER (WHERE is_first_order = 1) AS first_orders,
    ROUND(COUNT(*) FILTER (WHERE is_first_order = 1)::numeric / COUNT(*) * 100, 2) AS first_orders_share
FROM analytics.orders_discount
GROUP BY what_discount
ORDER BY what_discount DESC;

-- 3c. First orders by coupon code
SELECT
    coupon_code,
    COUNT(*) AS orders,
    COUNT(*) FILTER (WHERE is_first_order = 1) AS first_orders
FROM analytics.orders_discount
WHERE what_discount = 'coupon'
GROUP BY coupon_code
ORDER BY coupon_code DESC;


-- Part 4. Do discounts bring customers who come back?

-- 4a. Return rate, grouped by the type of the customer's first order
WITH all_orders AS (
SELECT
    main_customer_id,
    what_discount,
    is_first_order
FROM analytics.orders_discount),
first_orders AS (
SELECT *
FROM all_orders
WHERE is_first_order = 1),
customers AS (
SELECT
    ao.main_customer_id,
    fo.what_discount,
    COUNT(*) AS all_orders
FROM all_orders ao
LEFT JOIN first_orders fo ON ao.main_customer_id = fo.main_customer_id
GROUP BY ao.main_customer_id, fo.what_discount)
SELECT
    what_discount,
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE all_orders > 1) AS returned_customers,
    ROUND(COUNT(*) FILTER (WHERE all_orders > 1)::numeric / COUNT(*) * 100, 2) AS return_rate
FROM customers
GROUP BY what_discount;
