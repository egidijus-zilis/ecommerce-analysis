-- Q2. How seasonal is demand?
-- Data: analytics.orders_enriched, completed orders only.
-- Main year is 2025. 2026 (Jan-Sep) is a check. 2024 is left out (launch year).


-- Part 1. Overall

-- 1a. Orders and units by month, 2025 and 2026
WITH items AS (
    SELECT
        oi.order_id,
        oi.quantity,
        EXTRACT(YEAR FROM oe.order_date_local)::int  AS year,
        EXTRACT(MONTH FROM oe.order_date_local)::int AS month
    FROM clean.order_items oi
    JOIN analytics.orders_enriched oe ON oi.order_id = oe.order_id
    WHERE oe.order_status = 'completed'
)
SELECT
    month,
    COUNT(DISTINCT order_id) FILTER (WHERE year = 2025) AS orders_2025,
    COUNT(DISTINCT order_id) FILTER (WHERE year = 2026) AS orders_2026,
    SUM(quantity)            FILTER (WHERE year = 2025) AS units_2025,
    SUM(quantity)            FILTER (WHERE year = 2026) AS units_2026
FROM items
GROUP BY month
ORDER BY month;

-- 1b. November vs average month (2025)
WITH monthly AS (
    SELECT
        EXTRACT(MONTH FROM order_date_local)::int AS month,
        COUNT(*) AS orders
    FROM analytics.orders_enriched
    WHERE order_status = 'completed'
      AND EXTRACT(YEAR FROM order_date_local) = 2025
    GROUP BY 1
)
SELECT
    ROUND(AVG(orders), 1)                                 AS avg_orders_per_month,
    MAX(orders) FILTER (WHERE month = 11)                 AS orders_november,
    ROUND(MAX(orders) FILTER (WHERE month = 11) / AVG(orders), 2) AS november_vs_average
FROM monthly;

-- 1c. Orders per day in January and February (2025)
SELECT
    EXTRACT(MONTH FROM order_date_local)::int AS month,
    COUNT(*) AS orders,
    ROUND(COUNT(*)::numeric / COUNT(DISTINCT order_date_local), 1) AS orders_per_day
FROM analytics.orders_enriched
WHERE order_status = 'completed'
  AND EXTRACT(YEAR FROM order_date_local) = 2025
  AND EXTRACT(MONTH FROM order_date_local) IN (1, 2)
GROUP BY 1
ORDER BY 1;


-- Part 2. By category

-- 2a. Units by month and category (2025)
SELECT
    EXTRACT(MONTH FROM oe.order_date_local)::int AS month,
    SUM(oi.quantity) FILTER (WHERE p.category = 'Fashion')           AS fashion,
    SUM(oi.quantity) FILTER (WHERE p.category = 'Home & Kitchen')    AS home_kitchen,
    SUM(oi.quantity) FILTER (WHERE p.category = 'Beauty & Care')     AS beauty_care,
    SUM(oi.quantity) FILTER (WHERE p.category = 'Sports & Outdoors') AS sports_outdoors,
    SUM(oi.quantity) FILTER (WHERE p.category = 'Electronics')       AS electronics,
    SUM(oi.quantity) FILTER (WHERE p.category = 'Toys & Kids')       AS toys_kids,
    SUM(oi.quantity) FILTER (WHERE p.category = 'Pets')              AS pets,
    SUM(oi.quantity) FILTER (WHERE p.category = 'Garden')            AS garden,
    SUM(oi.quantity)                                                 AS total
FROM clean.order_items oi
JOIN clean.products p             ON oi.product_id = p.product_id
JOIN analytics.orders_enriched oe ON oi.order_id = oe.order_id
WHERE oe.order_status = 'completed'
  AND EXTRACT(YEAR FROM oe.order_date_local) = 2025
GROUP BY 1
ORDER BY 1;

-- 2b. Units by month and category (2026, Jan-Sep), to check 2025
SELECT
    EXTRACT(MONTH FROM oe.order_date_local)::int AS month,
    SUM(oi.quantity) FILTER (WHERE p.category = 'Fashion')           AS fashion,
    SUM(oi.quantity) FILTER (WHERE p.category = 'Home & Kitchen')    AS home_kitchen,
    SUM(oi.quantity) FILTER (WHERE p.category = 'Beauty & Care')     AS beauty_care,
    SUM(oi.quantity) FILTER (WHERE p.category = 'Sports & Outdoors') AS sports_outdoors,
    SUM(oi.quantity) FILTER (WHERE p.category = 'Electronics')       AS electronics,
    SUM(oi.quantity) FILTER (WHERE p.category = 'Toys & Kids')       AS toys_kids,
    SUM(oi.quantity) FILTER (WHERE p.category = 'Pets')              AS pets,
    SUM(oi.quantity) FILTER (WHERE p.category = 'Garden')            AS garden,
    SUM(oi.quantity)                                                 AS total
FROM clean.order_items oi
JOIN clean.products p             ON oi.product_id = p.product_id
JOIN analytics.orders_enriched oe ON oi.order_id = oe.order_id
WHERE oe.order_status = 'completed'
  AND EXTRACT(YEAR FROM oe.order_date_local) = 2026
GROUP BY 1
ORDER BY 1;


-- Part 3. Months to plan around
-- No query here. This part is based on the results of parts 1 and 2.
