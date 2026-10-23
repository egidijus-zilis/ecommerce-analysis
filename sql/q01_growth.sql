-- Q1. Is the business growing profitably?
-- Data: analytics.orders_enriched, completed orders only.


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
