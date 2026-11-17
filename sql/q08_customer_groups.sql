-- Q8. Which customers bring the most value?
-- Value = gross profit per customer in the first 180 days after the first order
-- (analytics.customer_value: gross_profit_180d, net_revenue_180d).
-- Only customers with the full 180 days (has_180d = 1, first order on or before 2026-04-03),
-- so older customers don't look better just because they had more time.
-- Only customers with the first order in 2025 or later. 2024 is left out,
-- because it was the launch year (lower order value), the same as in Q2.
-- Mean and median are both shown, because a few big customers pull the mean up.


-- Part 1. Countries

-- 1a. Value per customer by country
SELECT
    country,
    COUNT(*) AS customers,
    ROUND(AVG(net_revenue_180d), 2) AS net_revenue_per_customer,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY net_revenue_180d)::numeric, 2) AS median_net_revenue,
    ROUND(AVG(gross_profit_180d), 2) AS gross_profit_per_customer,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY gross_profit_180d)::numeric, 2) AS median_gross_profit
FROM analytics.customer_value
WHERE has_180d = 1
  AND first_order_date >= DATE '2025-01-01'
GROUP BY country
ORDER BY gross_profit_per_customer DESC;


-- Part 2. Cities

-- 2a. Value per customer by city (100+ customers, no Unknown)
SELECT
    city,
    COUNT(*) AS customers,
    ROUND(AVG(net_revenue_180d), 2) AS net_revenue_per_customer,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY net_revenue_180d)::numeric, 2) AS median_net_revenue,
    ROUND(AVG(gross_profit_180d), 2) AS gross_profit_per_customer,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY gross_profit_180d)::numeric, 2) AS median_gross_profit
FROM analytics.customer_value
WHERE has_180d = 1
  AND first_order_date >= DATE '2025-01-01'
  AND city <> 'Unknown'
GROUP BY city
HAVING COUNT(*) >= 100
ORDER BY gross_profit_per_customer DESC;

-- 2b. Customers with no city (left out of 2a)
SELECT
    COUNT(*) AS customers_no_city
FROM analytics.customer_value
WHERE has_180d = 1
  AND first_order_date >= DATE '2025-01-01'
  AND city = 'Unknown';


-- Part 3. Age

-- 3a. Value per customer by age group (age = 2026 - birth_year)
WITH customer_groups AS (
SELECT
    *,
    CASE
        WHEN 2026 - birth_year BETWEEN 18 AND 24 THEN '18-24'
        WHEN 2026 - birth_year BETWEEN 25 AND 34 THEN '25-34'
        WHEN 2026 - birth_year BETWEEN 35 AND 44 THEN '35-44'
        WHEN 2026 - birth_year BETWEEN 45 AND 54 THEN '45-54'
        WHEN 2026 - birth_year BETWEEN 55 AND 64 THEN '55-64'
        WHEN 2026 - birth_year >= 65 THEN '65+'
        ELSE 'unknown'
    END AS age_group
FROM analytics.customer_value
WHERE has_180d = 1
  AND first_order_date >= DATE '2025-01-01')
SELECT
    age_group,
    COUNT(*) AS customers,
    ROUND(AVG(net_revenue_180d), 2) AS net_revenue_per_customer,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY net_revenue_180d)::numeric, 2) AS median_net_revenue,
    ROUND(AVG(gross_profit_180d), 2) AS gross_profit_per_customer,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY gross_profit_180d)::numeric, 2) AS median_gross_profit
FROM customer_groups
GROUP BY age_group
ORDER BY age_group;


-- Part 4. Gender

-- 4a. Value per customer by gender
SELECT
    gender,
    COUNT(*) AS customers,
    ROUND(AVG(net_revenue_180d), 2) AS net_revenue_per_customer,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY net_revenue_180d)::numeric, 2) AS median_net_revenue,
    ROUND(AVG(gross_profit_180d), 2) AS gross_profit_per_customer,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY gross_profit_180d)::numeric, 2) AS median_gross_profit,
    ROUND(SUM(gross_profit_180d) / SUM(net_revenue_180d) * 100, 2) AS margin
FROM analytics.customer_value
WHERE has_180d = 1
  AND first_order_date >= DATE '2025-01-01'
GROUP BY gender
ORDER BY gross_profit_per_customer DESC;

-- 4b. Where men and women spend their money (order lines in the same 180 days)
WITH revenue AS (
SELECT
    oie.category,
    SUM(oie.net_revenue) FILTER (WHERE cv.gender = 'Male') AS male,
    SUM(oie.net_revenue) FILTER (WHERE cv.gender = 'Female') AS female
FROM analytics.order_items_enriched oie
JOIN analytics.customer_value cv ON cv.main_customer_id = oie.main_customer_id
WHERE cv.has_180d = 1
  AND cv.first_order_date >= DATE '2025-01-01'
  AND oie.order_date_local - cv.first_order_date <= 180
GROUP BY oie.category)
SELECT
    category,
    ROUND(male, 2) AS male_revenue,
    ROUND(male / SUM(male) OVER () * 100, 2) AS male_share,
    ROUND(female, 2) AS female_revenue,
    ROUND(female / SUM(female) OVER () * 100, 2) AS female_share
FROM revenue
ORDER BY male_share DESC;
