-- Q1. Is the business growing profitably?
-- Data: analytics.orders_enriched. Completed orders only, except 1c and 2c:
-- they also use 'shipped' and 'processing' orders to show how much
-- September 2026 can still grow (DQ-21).


-- Part 1. Month over month

-- 1a. Net revenue by month, one column per year
SELECT
    EXTRACT(MONTH FROM order_date_local)::int AS month,
    ROUND(SUM(CASE WHEN EXTRACT(YEAR FROM order_date_local) = 2024 THEN net_revenue END), 0) AS y2024,
    ROUND(SUM(CASE WHEN EXTRACT(YEAR FROM order_date_local) = 2025 THEN net_revenue END), 0) AS y2025,
    ROUND(SUM(CASE WHEN EXTRACT(YEAR FROM order_date_local) = 2026 THEN net_revenue END), 0) AS y2026
FROM analytics.orders_enriched
WHERE order_status = 'completed'
GROUP BY 1
ORDER BY 1;

-- 1b. Revenue, profit, orders and margin by month
SELECT
    EXTRACT(YEAR FROM order_date_local)::int  AS year,
    EXTRACT(MONTH FROM order_date_local)::int AS month,
    ROUND(SUM(gross_revenue), 2) AS gross_revenue,
    ROUND(SUM(net_revenue), 2)   AS net_revenue,
    ROUND(SUM(gross_profit), 2)  AS gross_profit,
    COUNT(order_id)              AS orders,
    ROUND(SUM(gross_profit) / SUM(net_revenue) * 100, 2) AS gross_margin_pct
FROM analytics.orders_enriched
WHERE order_status = 'completed'
GROUP BY 1, 2
ORDER BY 1, 2;

-- 1c. September 2026 is not complete
-- Data was taken on 2026-10-01. Orders from the last days of September 2026
-- are still 'shipped' or 'processing', so they are not in net revenue yet.
-- Upper bound: all open orders become completed and nothing is returned.
WITH september AS (
SELECT
    SUM(net_revenue) FILTER (WHERE order_date_local BETWEEN '2025-09-01' AND '2025-09-30') AS net_revenue_2025,
    SUM(net_revenue) FILTER (WHERE order_date_local BETWEEN '2026-09-01' AND '2026-09-30') AS net_revenue_2026,
    SUM(order_total - shipping_fee - returned_value) FILTER (WHERE order_date_local BETWEEN '2025-09-01' AND '2025-09-30'
                                                            AND order_status IN ('shipped', 'processing')) AS open_orders_2025,
    SUM(order_total - shipping_fee - returned_value) FILTER (WHERE order_date_local BETWEEN '2026-09-01' AND '2026-09-30'
                                                            AND order_status IN ('shipped', 'processing')) AS open_orders_2026
FROM analytics.orders_enriched)
SELECT
    COALESCE(open_orders_2025, 0) AS open_orders_2025,      -- check: must be 0
    ROUND(open_orders_2026, 2) AS open_orders_2026,
    ROUND((net_revenue_2026 - net_revenue_2025) / net_revenue_2025 * 100, 2) AS net_revenue_yoy_pct,
    ROUND((net_revenue_2026 + open_orders_2026 - net_revenue_2025) / net_revenue_2025 * 100, 2) AS net_revenue_yoy_pct_upper
FROM september;


-- Part 2. Year over year

-- 2a. Same period every year (Jan-Sep) and growth
WITH yearly AS (
    SELECT
        EXTRACT(YEAR FROM order_date_local)::int AS year,
        SUM(net_revenue)  AS net_revenue,
        SUM(gross_profit) AS gross_profit,
        COUNT(order_id)   AS orders
    FROM analytics.orders_enriched
    WHERE order_status = 'completed'
      AND EXTRACT(MONTH FROM order_date_local) <= 9
    GROUP BY 1
)
SELECT
    year,
    ROUND(net_revenue, 2)  AS net_revenue,
    ROUND(gross_profit, 2) AS gross_profit,
    orders,
    ROUND(net_revenue / orders, 2)                 AS avg_order_value,
    ROUND(gross_profit / net_revenue * 100, 2)     AS gross_margin_pct,
    ROUND((net_revenue - LAG(net_revenue) OVER (ORDER BY year))
          / LAG(net_revenue) OVER (ORDER BY year) * 100, 1) AS revenue_growth_pct
FROM yearly
ORDER BY year;

-- 2b. Full years (2026 has only Jan-Sep)
SELECT
    EXTRACT(YEAR FROM order_date_local)::int AS year,
    ROUND(SUM(net_revenue), 2)  AS net_revenue,
    ROUND(SUM(gross_profit), 2) AS gross_profit,
    COUNT(order_id)             AS orders
FROM analytics.orders_enriched
WHERE order_status = 'completed'
GROUP BY 1
ORDER BY 1;

-- 2c. January-September 2026 is not complete (DQ-21)
-- Same as 1c, but for January-September.
-- Upper bound: all open orders become completed and nothing is returned.
WITH jan_sep AS (
SELECT
    SUM(net_revenue) FILTER (WHERE order_date_local BETWEEN '2025-01-01' AND '2025-09-30') AS net_revenue_2025,
    SUM(net_revenue) FILTER (WHERE order_date_local BETWEEN '2026-01-01' AND '2026-09-30') AS net_revenue_2026,
    SUM(order_total - shipping_fee - returned_value) FILTER (WHERE order_date_local BETWEEN '2025-01-01' AND '2025-09-30'
                                                            AND order_status IN ('shipped', 'processing')) AS open_orders_2025,
    SUM(order_total - shipping_fee - returned_value) FILTER (WHERE order_date_local BETWEEN '2026-01-01' AND '2026-09-30'
                                                            AND order_status IN ('shipped', 'processing')) AS open_orders_2026
FROM analytics.orders_enriched)
SELECT
    COALESCE(open_orders_2025, 0) AS open_orders_2025,      -- check: must be 0
    ROUND(open_orders_2026, 2) AS open_orders_2026,
    ROUND((net_revenue_2026 - net_revenue_2025) / net_revenue_2025 * 100, 2) AS net_revenue_yoy_pct,
    ROUND((net_revenue_2026 + open_orders_2026 - net_revenue_2025) / net_revenue_2025 * 100, 2) AS net_revenue_yoy_pct_upper
FROM jan_sep;


-- Part 3. Where the growth comes from

-- 3a. New vs returning customers (Jan-Sep)
SELECT
    EXTRACT(YEAR FROM order_date_local)::int AS year,
    CASE
        WHEN EXTRACT(YEAR FROM first_order_ts) = EXTRACT(YEAR FROM order_date_local) THEN 'new'
        ELSE 'returning'
    END AS customer_type,
    COUNT(DISTINCT main_customer_id) AS customers,
    COUNT(order_id)                  AS orders,
    ROUND(SUM(net_revenue), 2)       AS net_revenue
FROM analytics.orders_enriched
WHERE order_status = 'completed'
  AND EXTRACT(MONTH FROM order_date_local) <= 9
GROUP BY 1, 2
ORDER BY 1, 2;
