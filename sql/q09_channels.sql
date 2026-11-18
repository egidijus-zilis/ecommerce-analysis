-- Q9. Which channels bring good customers?
-- Channel = acquisition_source of the person's main account (customer_id = main_customer_id).
-- Bought (part 1) = kept something: net revenue > 0 from completed orders within 30 days of sign-up.
-- Data ends 2026-09-30.


-- Part 1. Sign-ups who buy

-- 1a. Days from sign-up to first order (to choose the window)
WITH buyers AS (
SELECT
    cv.main_customer_id,
    cv.first_order_date - cc.signup_date AS days_to_buy
FROM analytics.customer_value cv
JOIN clean.customers cc ON cc.customer_id = cv.main_customer_id)
SELECT
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY days_to_buy)::numeric, 1) AS median_days,
    MIN(days_to_buy) AS min_days,
    ROUND(COUNT(*) FILTER (WHERE days_to_buy <= 7)::numeric / COUNT(*) * 100, 2) AS within_7_days,
    ROUND(COUNT(*) FILTER (WHERE days_to_buy <= 14)::numeric / COUNT(*) * 100, 2) AS within_14_days,
    ROUND(COUNT(*) FILTER (WHERE days_to_buy <= 30)::numeric / COUNT(*) * 100, 2) AS within_30_days
FROM buyers;

-- 1b. Share of sign-ups who bought, by channel
-- Only sign-ups up to 2026-08-31, so everyone had at least 30 days.
-- Bought = net revenue > 0 from orders within 30 days of sign-up.
-- So people who returned everything (net revenue 0) count as not bought.
-- Join on cc.customer_id = main_customer_id: one row per person, signup_date of the main account.
WITH customer_source AS (
SELECT
    cc.main_customer_id,
    cc.acquisition_source,
    cc.signup_date
FROM clean.customers cc
WHERE cc.customer_id = cc.main_customer_id),
revenue_30d AS (
SELECT
    aoe.main_customer_id,
    SUM(aoe.net_revenue) AS net_revenue_30d
FROM analytics.orders_enriched aoe
JOIN clean.customers cc ON aoe.main_customer_id = cc.customer_id
WHERE aoe.net_revenue > 0
  AND aoe.order_date_local - cc.signup_date <= 30
GROUP BY aoe.main_customer_id)
SELECT
    acquisition_source,
    COUNT(*) AS sign_ups,
    COUNT(*) FILTER (WHERE net_revenue_30d > 0) AS bought,
    ROUND(COUNT(*) FILTER (WHERE net_revenue_30d > 0)::numeric / COUNT(*) * 100, 2) AS bought_share
FROM customer_source cs
LEFT JOIN revenue_30d r ON r.main_customer_id = cs.main_customer_id
WHERE signup_date <= DATE '2026-08-31'
GROUP BY acquisition_source
ORDER BY bought_share DESC;


-- Part 2. Buyers who come back

-- 2a. Share of buyers who made a second order within 90 days, by channel
-- Only first orders before 2026-07-01, so everyone had 90 days.
SELECT
    acquisition_source,
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE second_order_date - first_order_date <= 90) AS returned_in_90_days,
    ROUND(COUNT(*) FILTER (WHERE second_order_date - first_order_date <= 90)::numeric / COUNT(*) * 100, 2) AS returning_share
FROM analytics.customer_value
WHERE first_order_date < DATE '2026-07-01'
GROUP BY acquisition_source
ORDER BY returning_share DESC;

-- 2b. Is each channel different from all other channels? (two-proportion z-test)
-- n1, x1 = buyers and returned buyers of this channel. n2, x2 = the same for all other channels.
-- p = both groups together. se = how much the share can move by chance.
-- 7 tests at once, so I use a stricter line: |z| >= 2.69 (0.05 / 7 tests, Bonferroni).
-- is_different = 'yes': the difference is unlikely to be chance.
WITH counts AS (
SELECT
    acquisition_source,
    COUNT(*) AS n1,
    COUNT(*) FILTER (WHERE second_order_date - first_order_date <= 90) AS x1
FROM analytics.customer_value
WHERE first_order_date < DATE '2026-07-01'
GROUP BY acquisition_source),
with_rest AS (
SELECT
    acquisition_source,
    n1,
    x1,
    SUM(n1) OVER () - n1 AS n2,
    SUM(x1) OVER () - x1 AS x2
FROM counts),
with_p AS (
SELECT
    *,
    x1::numeric / n1 AS p1,
    x2::numeric / n2 AS p2,
    (x1 + x2)::numeric / (n1 + n2) AS p
FROM with_rest)
SELECT
    acquisition_source,
    n1 AS buyers,
    ROUND(p1 * 100, 2) AS channel_share,
    ROUND(p2 * 100, 2) AS other_channels_share,
    ROUND((p1 - p2) / SQRT(p * (1 - p) * (1.0 / n1 + 1.0 / n2)), 2) AS z,
    CASE WHEN ABS((p1 - p2) / SQRT(p * (1 - p) * (1.0 / n1 + 1.0 / n2))) >= 2.69 THEN 'yes' ELSE 'no' END AS is_different
FROM with_p
ORDER BY z DESC;


-- Part 3. Profit per sign-up

-- 3a. Profit per sign-up in the first 180 days after sign-up
-- Only sign-ups up to 2026-04-03, so everyone had 180 days.
-- People who did not buy in these 180 days count as 0 EUR.
WITH sign_ups AS (
SELECT
    main_customer_id,
    acquisition_source,
    signup_date
FROM clean.customers
WHERE customer_id = main_customer_id
    AND signup_date <= DATE '2026-04-03'),
first_180_days AS (
SELECT
    su.main_customer_id,
    su.acquisition_source,
    COALESCE(SUM(oe.gross_profit), 0) AS gross_profit
FROM sign_ups su
LEFT JOIN analytics.orders_enriched oe
    ON oe.main_customer_id = su.main_customer_id
    AND oe.order_status = 'completed'
    AND oe.order_date_local - su.signup_date <= 180
GROUP BY su.main_customer_id, su.acquisition_source)
SELECT
    acquisition_source,
    COUNT(*) AS sign_ups,
    ROUND(SUM(gross_profit) / COUNT(*), 2) AS gross_profit_per_signup,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY gross_profit)::numeric, 2) AS median_gross_profit
FROM first_180_days
GROUP BY acquisition_source
ORDER BY gross_profit_per_signup DESC;
