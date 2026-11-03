-- Q8. Which customers bring the most value?
-- Value = gross profit per customer (analytics.customer_value, one row per customer).
-- Mean and median are both shown, because a few big customers pull the mean up.


-- Part 1. Countries

-- 1a. Value per customer by country
SELECT
    country,
    COUNT(*) AS customers,
    ROUND(SUM(net_revenue) / COUNT(*), 2) AS net_revenue_per_customer,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY net_revenue)::numeric, 2) AS median_net_revenue,
    ROUND(SUM(gross_profit) / COUNT(*), 2) AS gross_profit_per_customer,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY gross_profit)::numeric, 2) AS median_gross_profit
FROM analytics.customer_value
GROUP BY country
ORDER BY gross_profit_per_customer DESC;


-- Part 2. Cities

-- 2a. Value per customer by city (100+ customers, no Unknown)
SELECT
    city,
    COUNT(*) AS customers,
    ROUND(SUM(net_revenue) / COUNT(*), 2) AS net_revenue_per_customer,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY net_revenue)::numeric, 2) AS median_net_revenue,
    ROUND(SUM(gross_profit) / COUNT(*), 2) AS gross_profit_per_customer,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY gross_profit)::numeric, 2) AS median_gross_profit
FROM analytics.customer_value
WHERE city <> 'Unknown'
GROUP BY city
HAVING COUNT(*) >= 100
ORDER BY gross_profit_per_customer DESC;


-- Part 3. Age

-- 3a. Value per customer by age group (age = 2026 - birth_year)
WITH customer_age AS (
SELECT
    *,
    2026 - birth_year AS age
FROM analytics.customer_value),
customer_groups AS (
SELECT
    *,
    CASE
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        WHEN age >= 65 THEN '65+'
        ELSE 'unknown'
    END AS age_group
FROM customer_age)
SELECT
    age_group,
    COUNT(*) AS customers,
    ROUND(SUM(net_revenue) / COUNT(*), 2) AS net_revenue_per_customer,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY net_revenue)::numeric, 2) AS median_net_revenue,
    ROUND(SUM(gross_profit) / COUNT(*), 2) AS gross_profit_per_customer,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY gross_profit)::numeric, 2) AS median_gross_profit
FROM customer_groups
GROUP BY age_group
ORDER BY age_group;


-- Part 4. Gender

-- 4a. Value per customer by gender
SELECT
    gender,
    COUNT(*) AS customers,
    ROUND(SUM(net_revenue) / COUNT(*), 2) AS net_revenue_per_customer,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY net_revenue)::numeric, 2) AS median_net_revenue,
    ROUND(SUM(gross_profit) / COUNT(*), 2) AS gross_profit_per_customer,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY gross_profit)::numeric, 2) AS median_gross_profit,
    ROUND(SUM(gross_profit) / SUM(net_revenue) * 100, 2) AS margin
FROM analytics.customer_value
GROUP BY gender
ORDER BY gross_profit_per_customer DESC;

-- 4b. Where men and women spend their money (from order lines)
WITH revenue AS (
SELECT
    oie.category,
    SUM(oie.net_revenue) FILTER (WHERE cv.gender = 'Male') AS male,
    SUM(oie.net_revenue) FILTER (WHERE cv.gender = 'Female') AS female
FROM analytics.order_items_enriched oie
JOIN analytics.customer_value cv ON cv.main_customer_id = oie.main_customer_id
GROUP BY oie.category)
SELECT
    category,
    ROUND(male, 2) AS male_revenue,
    ROUND(male / SUM(male) OVER () * 100, 2) AS male_share,
    ROUND(female, 2) AS female_revenue,
    ROUND(female / SUM(female) OVER () * 100, 2) AS female_share
FROM revenue
ORDER BY male_share DESC;
