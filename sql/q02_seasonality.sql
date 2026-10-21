-- Q2. How seasonal is demand, overall and by category?
-- Data: completed orders. Main year 2025, 2026 (Jan-Sep) as a check. 2024 left out (launch year).


-- A. Orders and units by month, 2025 and 2026 side by side
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


-- B. Units by month and category (2025)
WITH items AS (
    SELECT
        oi.quantity,
        p.category,
        EXTRACT(YEAR FROM oe.order_date_local)::int  AS year,
        EXTRACT(MONTH FROM oe.order_date_local)::int AS month
    FROM clean.order_items oi
    JOIN clean.products p             ON oi.product_id = p.product_id
    JOIN analytics.orders_enriched oe ON oi.order_id = oe.order_id
    WHERE oe.order_status = 'completed'
)
SELECT
    month,
    SUM(quantity) FILTER (WHERE category = 'Fashion')           AS fashion,
    SUM(quantity) FILTER (WHERE category = 'Home & Kitchen')    AS home_kitchen,
    SUM(quantity) FILTER (WHERE category = 'Beauty & Care')     AS beauty_care,
    SUM(quantity) FILTER (WHERE category = 'Sports & Outdoors') AS sports_outdoors,
    SUM(quantity) FILTER (WHERE category = 'Electronics')       AS electronics,
    SUM(quantity) FILTER (WHERE category = 'Toys & Kids')       AS toys_kids,
    SUM(quantity) FILTER (WHERE category = 'Pets')              AS pets,
    SUM(quantity) FILTER (WHERE category = 'Garden')            AS garden,
    SUM(quantity)                                               AS total
FROM items
WHERE year = 2025
GROUP BY month
ORDER BY month;


-- C. Units by month and category (2026, Jan-Sep): check
WITH items AS (
    SELECT
        oi.quantity,
        p.category,
        EXTRACT(YEAR FROM oe.order_date_local)::int  AS year,
        EXTRACT(MONTH FROM oe.order_date_local)::int AS month
    FROM clean.order_items oi
    JOIN clean.products p             ON oi.product_id = p.product_id
    JOIN analytics.orders_enriched oe ON oi.order_id = oe.order_id
    WHERE oe.order_status = 'completed'
)
SELECT
    month,
    SUM(quantity) FILTER (WHERE category = 'Fashion')           AS fashion,
    SUM(quantity) FILTER (WHERE category = 'Home & Kitchen')    AS home_kitchen,
    SUM(quantity) FILTER (WHERE category = 'Beauty & Care')     AS beauty_care,
    SUM(quantity) FILTER (WHERE category = 'Sports & Outdoors') AS sports_outdoors,
    SUM(quantity) FILTER (WHERE category = 'Electronics')       AS electronics,
    SUM(quantity) FILTER (WHERE category = 'Toys & Kids')       AS toys_kids,
    SUM(quantity) FILTER (WHERE category = 'Pets')              AS pets,
    SUM(quantity) FILTER (WHERE category = 'Garden')            AS garden,
    SUM(quantity)                                               AS total
FROM items
WHERE year = 2026
GROUP BY month
ORDER BY month;

-- D. Orders per day in January and February (2025)
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