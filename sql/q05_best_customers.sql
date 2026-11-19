-- Q5. How much do we depend on our best customers?
-- Best customers = top 10% by gross profit (profit_group = 1 in analytics.customer_value).
-- Part 3c builds the top 10% again from analytics.orders_enriched, with orders only up to 2025-09-30.


-- Part 1. How much depends on them

-- 1a. Revenue, profit and orders by group
SELECT
    profit_group,
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
GROUP BY profit_group
ORDER BY profit_group;


-- Part 2. What they have in common

-- 2a. Country
WITH counts AS (
SELECT
    country,
    COUNT(*) FILTER (WHERE profit_group = 1) AS top10,
    COUNT(*) FILTER (WHERE profit_group <> 1) AS other90
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
    COUNT(*) FILTER (WHERE profit_group = 1) AS top10,
    COUNT(*) FILTER (WHERE profit_group <> 1) AS other90
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
    SUM(oie.net_revenue) FILTER (WHERE cv.profit_group = 1) AS top10,
    SUM(oie.net_revenue) FILTER (WHERE cv.profit_group <> 1) AS other90
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


-- Part 3. Best customers who stop buying

-- 3a. Average days between orders (NULL for customers with 1 order)
WITH top_customers AS (
SELECT
    main_customer_id,
    orders,
    (last_order_date - first_order_date)::numeric / NULLIF(orders - 1, 0) AS avg_days_between_orders
FROM analytics.customer_value
WHERE profit_group = 1)
SELECT
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE orders >= 2) AS customers_2plus_orders,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY avg_days_between_orders)::numeric, 1) AS median_days,
    ROUND(AVG(avg_days_between_orders), 1) AS average_days
FROM top_customers;

-- 3b. Active, at risk, lost today (data ends 2026-09-30)
-- Risk limit: 180 days for 1 order. For 2+ orders: 2 x own gap, kept between 90 and 180 days.
-- Lost: no order for more than 365 days.
WITH top_customers AS (
SELECT
    main_customer_id,
    orders,
    DATE '2026-09-30' - last_order_date AS days_since_last_order,
    (last_order_date - first_order_date)::numeric / NULLIF(orders - 1, 0) AS avg_days_between_orders
FROM analytics.customer_value
WHERE profit_group = 1),
with_limits AS (
SELECT
    *,
    CASE
        WHEN orders = 1 THEN 180
        ELSE LEAST(GREATEST(2 * avg_days_between_orders, 90), 180)
    END AS risk_limit_days
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
    ROUND(COUNT(*)::numeric / SUM(COUNT(*)) OVER () * 100, 2) AS customers_share
FROM with_status
GROUP BY status
ORDER BY
    CASE status
        WHEN 'active' THEN 1
        WHEN 'at_risk' THEN 2
        ELSE 3
    END;

-- 3c. Back-test: what did the best customers really do in the next 12 months?
-- I pretend that today is 2025-09-30. Only orders up to that date are used,
-- so the top 10% and the status don't know the future.
-- Top 10% (by gross profit) and status use the same rules as in 3b.
-- Then I take each customer's real gross profit from 2025-10-01 to 2026-09-30 (0 if no orders).
-- past_profit_per_year = profit per year before 2025-09-30 (all past profit / years as customer).
-- Every customer counts as at least 1 year.
-- Using it as next year's profit is the simple way. I compare it with the real profit next 12 months.
-- Bought = net revenue in the next 12 months > 0.
-- Limitation: returns made after 2025-09-30 are already taken out of the past net revenue.
WITH bt_orders AS (
SELECT
    main_customer_id,
    order_date_local,
    net_revenue,
    gross_profit
FROM analytics.orders_enriched
WHERE order_status = 'completed'
    AND order_date_local <= DATE '2025-09-30'),
bt_customers AS (
SELECT
    main_customer_id,
    SUM(net_revenue) AS net_revenue,
    SUM(gross_profit) AS gross_profit,
    COUNT(*) AS orders,
    MIN(order_date_local) AS first_order_date,
    MAX(order_date_local) AS last_order_date,
    (MAX(order_date_local) - MIN(order_date_local))::numeric / NULLIF(COUNT(*) - 1, 0) AS avg_days_between_orders
FROM bt_orders
GROUP BY main_customer_id),
bt_groups AS (
SELECT
    *,
    NTILE(10) OVER (ORDER BY gross_profit DESC, main_customer_id) AS profit_group
FROM bt_customers),
bt_limits AS (
SELECT
    *,
    DATE '2025-09-30' - last_order_date AS days_since_last_order,
    CASE
        WHEN orders = 1 THEN 180
        ELSE LEAST(GREATEST(2 * avg_days_between_orders, 90), 180)
    END AS risk_limit_days,
    gross_profit / (GREATEST(DATE '2025-09-30' - first_order_date, 365) / 365.0) AS past_profit_per_year
FROM bt_groups
WHERE profit_group = 1),
bt_status AS (
SELECT
    *,
    CASE
        WHEN days_since_last_order > 365 THEN 'lost'
        WHEN days_since_last_order > risk_limit_days THEN 'at_risk'
        ELSE 'active'
    END AS status
FROM bt_limits),
bt_future AS (
SELECT
    main_customer_id,
    SUM(net_revenue) AS future_revenue,
    SUM(gross_profit) AS future_profit
FROM analytics.orders_enriched
WHERE order_status = 'completed'
    AND order_date_local BETWEEN DATE '2025-10-01' AND DATE '2026-09-30'
GROUP BY main_customer_id),
bt_with_future AS (
SELECT
    s.*,
    COALESCE(f.future_revenue, 0) AS future_revenue,
    COALESCE(f.future_profit, 0) AS future_profit
FROM bt_status s
LEFT JOIN bt_future f ON f.main_customer_id = s.main_customer_id)
SELECT
    status,
    COUNT(*) AS customers,
    ROUND(COUNT(*) FILTER (WHERE future_revenue > 0)::numeric / COUNT(*) * 100, 2) AS bought_share,
    ROUND(SUM(past_profit_per_year), 2) AS past_profit_per_year,
    ROUND(SUM(future_profit), 2) AS profit_next_12m,
    ROUND(AVG(future_profit), 2) AS profit_per_customer_next_12m
FROM bt_with_future
GROUP BY status
ORDER BY
    CASE status
        WHEN 'active' THEN 1
        WHEN 'at_risk' THEN 2
        ELSE 3
    END;


-- 3d. What a win-back campaign could add (estimate)
-- 3c and 3b CTEs are repeated, so both can be used in one query.
-- I assume today's at risk customers act like the 2025 ones (3c).
-- est_gp_no_action = GP they will likely bring anyway.
-- est_gp_if_like_active = GP if all of them bought like active customers.
-- est_extra_gp = what a campaign could add (rough estimate from one back-test). Real result will likely be lower.
WITH bt_orders AS (
SELECT
    main_customer_id,
    order_date_local,
    net_revenue,
    gross_profit
FROM analytics.orders_enriched
WHERE order_status = 'completed'
    AND order_date_local <= DATE '2025-09-30'),
bt_customers AS (
SELECT
    main_customer_id,
    SUM(net_revenue) AS net_revenue,
    SUM(gross_profit) AS gross_profit,
    COUNT(*) AS orders,
    MIN(order_date_local) AS first_order_date,
    MAX(order_date_local) AS last_order_date,
    (MAX(order_date_local) - MIN(order_date_local))::numeric / NULLIF(COUNT(*) - 1, 0) AS avg_days_between_orders
FROM bt_orders
GROUP BY main_customer_id),
bt_groups AS (
SELECT
    *,
    NTILE(10) OVER (ORDER BY gross_profit DESC, main_customer_id) AS profit_group
FROM bt_customers),
bt_limits AS (
SELECT
    *,
    DATE '2025-09-30' - last_order_date AS days_since_last_order,
    CASE
        WHEN orders = 1 THEN 180
        ELSE LEAST(GREATEST(2 * avg_days_between_orders, 90), 180)
    END AS risk_limit_days
FROM bt_groups
WHERE profit_group = 1),
bt_status AS (
SELECT
    *,
    CASE
        WHEN days_since_last_order > 365 THEN 'lost'
        WHEN days_since_last_order > risk_limit_days THEN 'at_risk'
        ELSE 'active'
    END AS status
FROM bt_limits),
bt_future AS (
SELECT
    main_customer_id,
    SUM(gross_profit) AS future_profit
FROM analytics.orders_enriched
WHERE order_status = 'completed'
    AND order_date_local BETWEEN DATE '2025-10-01' AND DATE '2026-09-30'
GROUP BY main_customer_id),
bt_with_future AS (
SELECT
    s.*,
    COALESCE(f.future_profit, 0) AS future_profit
FROM bt_status s
LEFT JOIN bt_future f ON f.main_customer_id = s.main_customer_id),
top_customers AS (
SELECT
    main_customer_id,
    orders,
    DATE '2026-09-30' - last_order_date AS days_since_last_order,
    (last_order_date - first_order_date)::numeric / NULLIF(orders - 1, 0) AS avg_days_between_orders
FROM analytics.customer_value
WHERE profit_group = 1),
with_limits AS (
SELECT
    *,
    CASE
        WHEN orders = 1 THEN 180
        ELSE LEAST(GREATEST(2 * avg_days_between_orders, 90), 180)
    END AS risk_limit_days
FROM top_customers),
with_status AS (
SELECT
    *,
    CASE
        WHEN days_since_last_order > 365 THEN 'lost'
        WHEN days_since_last_order > risk_limit_days THEN 'at_risk'
        ELSE 'active'
    END AS status
FROM with_limits),
backtest AS (
SELECT
    AVG(future_profit) FILTER (WHERE status = 'at_risk') AS x,
    AVG(future_profit) FILTER (WHERE status = 'active') AS y
FROM bt_with_future),
today AS (
SELECT
    COUNT(*) FILTER (WHERE status = 'at_risk') AS at_risk_today
FROM with_status)
SELECT
    at_risk_today,
    ROUND(at_risk_today * x, 2) AS est_gp_no_action,
    ROUND(at_risk_today * y, 2) AS est_gp_if_like_active,
    ROUND(at_risk_today * (y - x), 2) AS est_extra_gp
FROM backtest CROSS JOIN today;
