-- Q3. Which products earn the most profit?
-- Data: analytics.product_performance (see sql/12_analytics_product_performance.sql)


-- Part 1. Most and least profit

-- 1a. Profit by category
SELECT
    category,
    COUNT(*)          AS products,
    SUM(net_revenue)  AS net_revenue,
    SUM(gross_profit) AS gross_profit,
    ROUND(SUM(gross_profit) / NULLIF(SUM(net_revenue), 0) * 100, 2) AS gross_margin
FROM analytics.product_performance
GROUP BY category
ORDER BY gross_profit DESC;

-- 1b. Top 5 active products by profit per month
SELECT
    pp.product_id,
    pp.product_name,
    pp.profit_per_month,
    pp.gross_margin,
    p.list_price,
    pp.product_recommendation
FROM analytics.product_performance pp
LEFT JOIN clean.products p ON pp.product_id = p.product_id
WHERE pp.is_active = 'yes'
ORDER BY pp.profit_per_month DESC NULLS LAST
LIMIT 5;

-- 1c. Bottom 5 active products by profit per month
SELECT
    pp.product_id,
    pp.product_name,
    pp.profit_per_month,
    pp.gross_margin,
    p.list_price,
    pp.product_recommendation
FROM analytics.product_performance pp
LEFT JOIN clean.products p ON pp.product_id = p.product_id
WHERE pp.is_active = 'yes'
ORDER BY pp.profit_per_month ASC
LIMIT 5;


-- Part 2. Reprice, promote or drop
-- Step 1: ABC analysis. C products always go to review.
-- Step 2: A and B products are put in groups by units per month and profit per unit.

-- 2a. Medians (active products only)
SELECT DISTINCT
    median_units_per_month,
    median_profit_per_unit
FROM analytics.product_performance;

-- 2b. Products by ABC class (active products)
SELECT
    abc_class,
    COUNT(*)          AS products,
    SUM(gross_profit) AS gross_profit
FROM analytics.product_performance
WHERE is_active = 'yes'
GROUP BY abc_class
ORDER BY abc_class;

-- 2c. Check: active products that lose money (expected 0)
SELECT COUNT(*) AS products_with_loss
FROM analytics.product_performance
WHERE is_active = 'yes' AND gross_profit < 0;

-- 2d. Summary by group (active products)
SELECT
    product_recommendation,
    COUNT(*)          AS products,
    SUM(gross_profit) AS gross_profit,
    ROUND(SUM(gross_profit) / SUM(SUM(gross_profit)) OVER () * 100.0, 2) AS gross_profit_share
FROM analytics.product_performance
WHERE is_active = 'yes'
GROUP BY product_recommendation
ORDER BY gross_profit_share DESC NULLS LAST;

-- 2e. Top 5 reprice: people buy them often, but each sale earns little
SELECT product_id, product_name, category, units_per_month, profit_per_unit, profit_per_month
FROM analytics.product_performance
WHERE is_active = 'yes' AND product_recommendation = 'reprice'
ORDER BY units_per_month DESC
LIMIT 5;

-- 2f. Top 5 promote: each sale earns a lot, but people buy them rarely
SELECT product_id, product_name, category, units_per_month, profit_per_unit, profit_per_month
FROM analytics.product_performance
WHERE is_active = 'yes' AND product_recommendation = 'promote'
ORDER BY profit_per_unit DESC
LIMIT 5;

-- 2g. Top 5 review: earn the least per month
SELECT product_id, product_name, category, units_per_month, profit_per_unit, profit_per_month
FROM analytics.product_performance
WHERE is_active = 'yes' AND product_recommendation = 'review'
ORDER BY profit_per_month ASC
LIMIT 5;

-- 2h. Discontinued products by group
SELECT
    product_recommendation,
    COUNT(*) AS products
FROM analytics.product_performance
WHERE is_active = 'no'
GROUP BY product_recommendation;

-- 2i. Discontinued products in 'keep': maybe bring back
SELECT product_id, product_name, category, sales_end, units_per_month, profit_per_unit, profit_per_month
FROM analytics.product_performance
WHERE is_active = 'no' AND product_recommendation = 'keep'
ORDER BY profit_per_month DESC;
