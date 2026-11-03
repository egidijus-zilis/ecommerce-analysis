-- Q7. How much do we depend on our best customers?
-- Best customers = top 10% by net revenue (revenue_group = 1 in analytics.customer_value).


-- Part 1. How much depends on them

-- 1a. Revenue, profit and orders by group
SELECT
    revenue_group,
    COUNT(*) AS customers,
    ROUND(SUM(net_revenue), 2) AS net_revenue,
    ROUND(SUM(net_revenue) / SUM(SUM(net_revenue)) OVER () * 100, 2) AS revenue_share,
    ROUND(SUM(gross_profit), 2) AS gross_profit,
    ROUND(SUM(gross_profit) / SUM(SUM(gross_profit)) OVER () * 100, 2) AS profit_share,
    ROUND(SUM(gross_profit) / SUM(net_revenue) * 100, 2) AS margin,
    SUM(orders) AS orders,
    ROUND(SUM(net_revenue) / SUM(orders), 2) AS aov,
    ROUND(SUM(orders)::numeric / COUNT(*), 2) AS orders_per_customer
FROM analytics.customer_value
GROUP BY revenue_group
ORDER BY revenue_group;


-- Part 2. What they have in common

-- 2a. Country
WITH counts AS (
SELECT
    country,
    COUNT(*) FILTER (WHERE revenue_group = 1) AS top10,
    COUNT(*) FILTER (WHERE revenue_group <> 1) AS other90
FROM analytics.customer_value
GROUP BY country)
SELECT
    country,
    top10,
    ROUND(top10 * 100.0 / SUM(top10) OVER (), 2) AS top10_share,
    other90,
    ROUND(other90 * 100.0 / SUM(other90) OVER (), 2) AS other90_share
FROM counts
ORDER BY country;

-- 2b. Acquisition channel
-- in_top10 = share of the channel's customers who are in the top 10%
WITH counts AS (
SELECT
    acquisition_source,
    COUNT(*) FILTER (WHERE revenue_group = 1) AS top10,
    COUNT(*) FILTER (WHERE revenue_group <> 1) AS other90
FROM analytics.customer_value
GROUP BY acquisition_source)
SELECT
    acquisition_source,
    top10,
    ROUND(top10 * 100.0 / SUM(top10) OVER (), 2) AS top10_share,
    other90,
    ROUND(other90 * 100.0 / SUM(other90) OVER (), 2) AS other90_share,
    ROUND(top10 * 100.0 / (top10 + other90), 2) AS in_top10
FROM counts
ORDER BY top10_share DESC;

-- 2c. Category (from order lines)
WITH revenue AS (
SELECT
    oie.category,
    SUM(oie.net_revenue) FILTER (WHERE cv.revenue_group = 1) AS top10,
    SUM(oie.net_revenue) FILTER (WHERE cv.revenue_group <> 1) AS other90
FROM analytics.order_items_enriched oie
JOIN analytics.customer_value cv ON cv.main_customer_id = oie.main_customer_id
GROUP BY oie.category)
SELECT
    category,
    ROUND(top10, 2) AS top10_revenue,
    ROUND(top10 / SUM(top10) OVER () * 100, 2) AS top10_share,
    ROUND(other90, 2) AS other90_revenue,
    ROUND(other90 / SUM(other90) OVER () * 100, 2) AS other90_share
FROM revenue
ORDER BY top10_share DESC;


-- Part 3. Revenue at risk

-- 3a. Average days between orders (NULL for customers with 1 order)
WITH top_customers AS (
SELECT
    main_customer_id,
    orders,
    (last_order_date - first_order_date)::numeric / NULLIF(orders - 1, 0) AS avg_days_between_orders
FROM analytics.customer_value
WHERE revenue_group = 1)
SELECT
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE orders >= 2) AS customers_2plus_orders,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY avg_days_between_orders)::numeric, 1) AS median_days,
    ROUND(AVG(avg_days_between_orders), 1) AS average_days
FROM top_customers;

-- 3b. Active, at risk, lost (data ends 2026-09-30)
-- Risk limit: 180 days for 1 order. For 2+ orders: 2 x own gap, kept between 90 and 180 days.
-- Lost: no order for more than 365 days.
-- Per year: every customer counts as at least 1 year.
WITH top_customers AS (
SELECT
    main_customer_id,
    orders,
    net_revenue,
    gross_profit,
    DATE '2026-09-30' - last_order_date AS days_since_last_order,
    (last_order_date - first_order_date)::numeric / NULLIF(orders - 1, 0) AS avg_days_between_orders,
    GREATEST(DATE '2026-09-30' - first_order_date, 365) / 365.0 AS years_as_customer
FROM analytics.customer_value
WHERE revenue_group = 1),
with_limits AS (
SELECT
    *,
    CASE
        WHEN orders = 1 THEN 180
        ELSE LEAST(GREATEST(2 * avg_days_between_orders, 90), 180)
    END AS risk_limit_days,
    net_revenue / years_as_customer AS revenue_per_year,
    gross_profit / years_as_customer AS profit_per_year
FROM top_customers),
with_status AS (
SELECT
    *,
    CASE
        WHEN days_since_last_order > 365 THEN 'lost'
        WHEN days_since_last_order > risk_limit_days THEN 'at_risk'
        ELSE 'active'
    END AS status
FROM with_limits)
SELECT
    status,
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE orders = 1) AS one_order,
    COUNT(*) FILTER (WHERE orders = 2) AS two_orders,
    COUNT(*) FILTER (WHERE orders >= 3) AS three_plus_orders,
    ROUND(COUNT(*)::numeric / SUM(COUNT(*)) OVER () * 100, 2) AS customers_share,
    ROUND(SUM(revenue_per_year), 2) AS revenue_per_year,
    ROUND(SUM(revenue_per_year) / SUM(SUM(revenue_per_year)) OVER () * 100, 2) AS revenue_share,
    ROUND(SUM(profit_per_year), 2) AS profit_per_year
FROM with_status
GROUP BY status
ORDER BY
    CASE status
        WHEN 'active' THEN 1
        WHEN 'at_risk' THEN 2
        ELSE 3
    END;