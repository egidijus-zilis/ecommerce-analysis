-- Q3: Product profit
-- Which products should we keep, promote, reprice or review?
-- Data: analytics.product_performance (see sql/12_analytics_product_performance.sql)


-- 1. Profit by category
SELECT
    category,
    COUNT(*)                    AS products,
    SUM(net_revenue)            AS net_revenue,
    SUM(gross_profit)           AS gross_profit,
    ROUND(SUM(gross_profit) / NULLIF(SUM(net_revenue), 0) * 100, 2) AS gross_margin
FROM analytics.product_performance
GROUP BY category
ORDER BY gross_profit DESC;


-- 2. Medians (active products only)
SELECT DISTINCT
    median_units_per_month,
    median_margin
FROM analytics.product_performance;


-- 3. Check: active products that lose money (expected 0)
SELECT COUNT(*) AS products_with_loss
FROM analytics.product_performance
WHERE is_active = 'yes' AND gross_profit < 0;


-- 4. Summary by group (active products)
SELECT
    product_recommendation,
    COUNT(*)          AS products,
    SUM(gross_profit) AS gross_profit,
    ROUND(SUM(gross_profit) / SUM(SUM(gross_profit)) OVER () * 100.0, 2) AS gross_profit_share
FROM analytics.product_performance
WHERE is_active = 'yes'
GROUP BY product_recommendation
ORDER BY gross_profit_share DESC NULLS LAST;


-- 5. Top 5 reprice: sell well, low margin
SELECT product_id, product_name, category, units_per_month, gross_margin, profit_per_month
FROM analytics.product_performance
WHERE is_active = 'yes' AND product_recommendation = 'reprice'
ORDER BY units_per_month DESC
LIMIT 5;


-- 6. Top 5 promote: high margin, sell little
SELECT product_id, product_name, category, units_per_month, gross_margin, profit_per_month
FROM analytics.product_performance
WHERE is_active = 'yes' AND product_recommendation = 'promote'
ORDER BY gross_margin DESC
LIMIT 5;


-- 7. Top 5 review: earn the least per month
SELECT product_id, product_name, category, units_per_month, gross_margin, profit_per_month
FROM analytics.product_performance
WHERE is_active = 'yes' AND product_recommendation = 'review'
ORDER BY profit_per_month ASC
LIMIT 5;


-- 8. Discontinued products by group
SELECT
    product_recommendation,
    COUNT(*) AS products
FROM analytics.product_performance
WHERE is_active = 'no'
GROUP BY product_recommendation;


-- 9. Discontinued products in 'keep': maybe bring back
SELECT product_id, product_name, category, sales_end, units_per_month, gross_margin, profit_per_month
FROM analytics.product_performance
WHERE is_active = 'no' AND product_recommendation = 'keep'
ORDER BY profit_per_month DESC;