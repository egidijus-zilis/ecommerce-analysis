DROP VIEW IF EXISTS analytics.product_performance;

CREATE VIEW analytics.product_performance AS
WITH product_time AS (
SELECT
    p.product_id,
    p.product_name,
    p.category,
    GREATEST(p.launch_date, DATE '2024-01-01') AS sales_start,
    COALESCE(p.discontinued_date, DATE '2026-09-30') AS sales_end,
    CASE WHEN p.discontinued_date IS NULL THEN 'yes' ELSE 'no' END AS is_active,
    ROUND((COALESCE(p.discontinued_date, DATE '2026-09-30') - GREATEST(p.launch_date, DATE '2024-01-01')) / 30.4, 2) AS months_on_sale
FROM clean.products p),
sales AS (
SELECT
    product_id,
    SUM(quantity) FILTER (WHERE order_status = 'completed') AS units,
    ROUND(SUM(net_revenue), 2)  AS net_revenue,
    ROUND(SUM(gross_profit), 2) AS gross_profit,
    ROUND(SUM(gross_profit) / NULLIF(SUM(net_revenue), 0) * 100, 2) AS gross_margin
FROM analytics.order_items_enriched
GROUP BY product_id),
product_stats AS (
SELECT
    pt.*,
    s.units,
    s.net_revenue,
    s.gross_profit,
    s.gross_margin,
    ROUND(s.gross_profit / NULLIF(s.units, 0), 2) AS profit_per_unit,
    ROUND(s.units / NULLIF(pt.months_on_sale, 0), 2) AS units_per_month,
    ROUND(s.gross_profit / NULLIF(pt.months_on_sale, 0), 2) AS profit_per_month
FROM product_time pt
LEFT JOIN sales s ON pt.product_id = s.product_id),
medians AS (
SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY units_per_month) AS median_units_per_month,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY profit_per_unit) AS median_profit_per_unit
FROM product_stats
WHERE is_active = 'yes'),
profit_ranking AS (
SELECT
    product_id,
    SUM(profit_per_month) OVER (ORDER BY profit_per_month DESC) / SUM(profit_per_month) OVER () * 100 AS share
FROM product_stats
WHERE is_active = 'yes'),
abc_classes AS (
SELECT
    product_id,
    CASE
        WHEN share IS NULL THEN 'no_sales'
        WHEN share < 80 THEN 'A'
        WHEN share < 95 THEN 'B'
        ELSE 'C'
    END AS abc_class
FROM profit_ranking),
final AS (
SELECT
    ps.*,
    m.median_units_per_month,
    m.median_profit_per_unit,
    a.abc_class,
    CASE
        WHEN a.abc_class = 'C' THEN 'review'
        WHEN ps.units_per_month >= m.median_units_per_month AND ps.profit_per_unit >= m.median_profit_per_unit THEN 'keep'
        WHEN ps.units_per_month >= m.median_units_per_month AND ps.profit_per_unit <  m.median_profit_per_unit THEN 'reprice'
        WHEN ps.units_per_month <  m.median_units_per_month AND ps.profit_per_unit >= m.median_profit_per_unit THEN 'promote'
        WHEN ps.units_per_month <  m.median_units_per_month AND ps.profit_per_unit <  m.median_profit_per_unit THEN 'review'
        ELSE 'no_sales'
    END AS product_recommendation
FROM product_stats ps
CROSS JOIN medians m
LEFT JOIN abc_classes a ON ps.product_id = a.product_id)
SELECT *
FROM final;