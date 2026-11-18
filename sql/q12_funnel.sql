-- Q12. Where do shoppers stop before buying?
-- Data: clean.user_events (bot and double purchase events already removed).
-- Each step counts sessions that had this event at least once.
-- Share = sessions that reached this step / sessions in the step before.


-- Part 1. Where shoppers stop

-- 1a. Funnel for all sessions
WITH steps AS (
SELECT
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'view_item') AS view_item,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'add_to_cart') AS add_to_cart,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'begin_checkout') AS begin_checkout,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'add_payment_info') AS add_payment_info,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'purchase') AS purchase
FROM clean.user_events)
SELECT
    *,
    ROUND(add_to_cart::numeric / view_item * 100, 2) AS view_to_cart,
    ROUND(begin_checkout::numeric / add_to_cart * 100, 2) AS cart_to_checkout,
    ROUND(add_payment_info::numeric / begin_checkout * 100, 2) AS checkout_to_payment,
    ROUND(purchase::numeric / add_payment_info * 100, 2) AS payment_to_purchase,
    ROUND(purchase::numeric / view_item * 100, 2) AS view_to_purchase
FROM steps;


-- Part 2. By device

-- 2a. Funnel by device
WITH steps AS (
SELECT
    device,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'view_item') AS view_item,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'add_to_cart') AS add_to_cart,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'begin_checkout') AS begin_checkout,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'add_payment_info') AS add_payment_info,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'purchase') AS purchase
FROM clean.user_events
GROUP BY device)
SELECT
    *,
    ROUND(add_to_cart::numeric / view_item * 100, 2) AS view_to_cart,
    ROUND(begin_checkout::numeric / add_to_cart * 100, 2) AS cart_to_checkout,
    ROUND(add_payment_info::numeric / begin_checkout * 100, 2) AS checkout_to_payment,
    ROUND(purchase::numeric / add_payment_info * 100, 2) AS payment_to_purchase,
    ROUND(purchase::numeric / view_item * 100, 2) AS view_to_purchase
FROM steps
ORDER BY view_to_purchase DESC;


-- Part 3. By traffic source

-- 3a. Funnel by traffic source
WITH steps AS (
SELECT
    traffic_source,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'view_item') AS view_item,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'add_to_cart') AS add_to_cart,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'begin_checkout') AS begin_checkout,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'add_payment_info') AS add_payment_info,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'purchase') AS purchase
FROM clean.user_events
GROUP BY traffic_source)
SELECT
    *,
    ROUND(add_to_cart::numeric / view_item * 100, 2) AS view_to_cart,
    ROUND(begin_checkout::numeric / add_to_cart * 100, 2) AS cart_to_checkout,
    ROUND(add_payment_info::numeric / begin_checkout * 100, 2) AS checkout_to_payment,
    ROUND(purchase::numeric / add_payment_info * 100, 2) AS payment_to_purchase,
    ROUND(purchase::numeric / view_item * 100, 2) AS view_to_purchase
FROM steps
ORDER BY view_to_purchase DESC;

-- 3b. Traffic source and device together
-- Checks if paid_social is weak only because most of its sessions are on mobile.
WITH steps AS (
SELECT
    traffic_source,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'view_item') AS sessions,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'view_item' AND device = 'mobile') AS mobile_sessions,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'view_item' AND device = 'desktop') AS desktop_view,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'purchase' AND device = 'desktop') AS desktop_purchase,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'view_item' AND device = 'mobile') AS mobile_view,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'purchase' AND device = 'mobile') AS mobile_purchase,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'begin_checkout' AND device = 'mobile') AS mobile_checkout,
    COUNT(DISTINCT session_id) FILTER (WHERE event_type = 'add_payment_info' AND device = 'mobile') AS mobile_payment
FROM clean.user_events
GROUP BY traffic_source)
SELECT
    traffic_source,
    ROUND(mobile_sessions::numeric / sessions * 100, 2) AS mobile_share,
    ROUND(desktop_purchase::numeric / desktop_view * 100, 2) AS desktop_view_to_purchase,
    ROUND(mobile_purchase::numeric / mobile_view * 100, 2) AS mobile_view_to_purchase,
    ROUND(mobile_payment::numeric / mobile_checkout * 100, 2) AS mobile_checkout_to_payment
FROM steps
ORDER BY mobile_view_to_purchase DESC;


-- Part 4. What if the mobile checkout step worked like desktop?
-- I use the last 12 months (2025-10-01 to 2026-09-30). The business grows,
-- so an average over all years would be too low for the next year.

-- 4a. Gross profit from mobile orders, last 12 months
-- An order gets its device from its session (clean.orders.session_id).
-- Cancelled and open orders have gross_profit 0.
SELECT
    ROUND(SUM(aoe.gross_profit), 2) AS gross_profit_mobile
FROM analytics.orders_enriched aoe
JOIN clean.orders o ON aoe.order_id = o.order_id
JOIN analytics.session_funnel asf ON o.session_id = asf.session_id
WHERE asf.device = 'mobile'
  AND aoe.order_date_local BETWEEN DATE '2025-10-01' AND DATE '2026-09-30';

-- Check (all data): orders with a known device + order 1240 (left out, DQ-13) should equal purchase sessions in part 1 (9,672 + 1 = 9,673).
SELECT
    COUNT(*) AS orders_with_device
FROM analytics.orders_enriched aoe
JOIN clean.orders o ON aoe.order_id = o.order_id
JOIN analytics.session_funnel asf ON o.session_id = asf.session_id;

-- 4b. Open mobile orders in September 2026 (not completed, not cancelled, DQ-21)
-- Their gross profit is 0 in 4a. possible_gross_profit = if all of them are completed and nothing is returned.
SELECT
    COUNT(*) AS open_orders,
    ROUND(SUM(aoe.order_total), 2) AS order_total,
    ROUND(SUM(aoe.order_total - aoe.shipping_fee - aoe.returned_value), 2) AS possible_net_revenue,
    ROUND(SUM(aoe.order_total - aoe.shipping_fee - aoe.returned_value - aoe.cost), 2) AS possible_gross_profit
FROM analytics.orders_enriched aoe
JOIN clean.orders o ON o.order_id = aoe.order_id
JOIN analytics.session_funnel asf ON asf.session_id = o.session_id
WHERE asf.device = 'mobile'
  AND aoe.order_status NOT IN ('completed', 'cancelled')
  AND aoe.order_date_local BETWEEN DATE '2026-09-01' AND DATE '2026-09-30';

-- 4c. Extra gross profit per year if mobile checkout -> payment was like desktop (estimate)
-- Funnel conversion is a product of steps. If only one step changes,
-- new = old * (new step rate / old step rate).
-- I assume the other steps and profit per order stay the same.
-- Rates and gross profit are from the same 12 months.
-- extra_gross_profit = base from completed orders (4a).
-- extra_gross_profit_upper = base + open mobile orders (4b).
WITH rates AS (
SELECT
    SUM(has_payment) FILTER (WHERE device = 'mobile')::numeric / SUM(has_checkout) FILTER (WHERE device = 'mobile') AS checkout_to_payment_mobile,
    SUM(has_payment) FILTER (WHERE device = 'desktop')::numeric / SUM(has_checkout) FILTER (WHERE device = 'desktop') AS checkout_to_payment_desktop
FROM analytics.session_funnel
WHERE session_date BETWEEN DATE '2025-10-01' AND DATE '2026-09-30'),
mobile_profit AS (
SELECT
    SUM(aoe.gross_profit) AS gross_profit_mobile
FROM analytics.orders_enriched aoe
JOIN clean.orders o ON aoe.order_id = o.order_id
JOIN analytics.session_funnel asf ON o.session_id = asf.session_id
WHERE asf.device = 'mobile'
  AND aoe.order_date_local BETWEEN DATE '2025-10-01' AND DATE '2026-09-30'),
open_profit AS (
SELECT
    SUM(aoe.order_total - aoe.shipping_fee - aoe.returned_value - aoe.cost) AS possible_gross_profit
FROM analytics.orders_enriched aoe
JOIN clean.orders o ON o.order_id = aoe.order_id
JOIN analytics.session_funnel asf ON asf.session_id = o.session_id
WHERE asf.device = 'mobile'
  AND aoe.order_status NOT IN ('completed', 'cancelled')
  AND aoe.order_date_local BETWEEN DATE '2026-09-01' AND DATE '2026-09-30')
SELECT
    ROUND(checkout_to_payment_mobile * 100, 2) AS mobile_rate,
    ROUND(checkout_to_payment_desktop * 100, 2) AS desktop_rate,
    ROUND(gross_profit_mobile * (checkout_to_payment_desktop / checkout_to_payment_mobile), 2) AS new_gross_profit_mobile,
    ROUND(gross_profit_mobile * (checkout_to_payment_desktop / checkout_to_payment_mobile) - gross_profit_mobile, 2) AS extra_gross_profit,
    ROUND((gross_profit_mobile + possible_gross_profit) * (checkout_to_payment_desktop / checkout_to_payment_mobile) - (gross_profit_mobile + possible_gross_profit), 2) AS extra_gross_profit_upper
FROM rates, mobile_profit, open_profit;
