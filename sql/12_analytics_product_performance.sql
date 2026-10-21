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
product_stats AS  (
SELECT
	pt.*,
	s.units,
	s.net_revenue,
	s.gross_profit,
	s.gross_margin,
	ROUND(units / NULLIF(months_on_sale, 0), 2) AS units_per_month,
	ROUND(gross_profit / NULLIF(months_on_sale, 0), 2) AS profit_per_month
FROM product_time pt
LEFT JOIN sales s ON pt.product_id = s.product_id),
medians AS(
SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY units_per_month) AS median_units_per_month,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY gross_margin)    AS median_margin
FROM product_stats ps
WHERE is_active = 'yes'
),
final AS (
SELECT ps.*,
m.median_units_per_month,
m.median_margin,
CASE
	WHEN ps.units_per_month >= m.median_units_per_month AND ps.gross_margin >= m.median_margin THEN 'keep'
	WHEN ps.units_per_month >= m.median_units_per_month AND ps.gross_margin < m.median_margin THEN 'reprice'
	WHEN ps.units_per_month < m.median_units_per_month AND ps.gross_margin >= m.median_margin THEN 'promote'
	WHEN ps.units_per_month < m.median_units_per_month AND ps.gross_margin < m.median_margin THEN 'review'
	ELSE 'no_sales'
END AS product_recommendation
FROM product_stats ps
CROSS JOIN medians m)
SELECT * 
FROM final;
