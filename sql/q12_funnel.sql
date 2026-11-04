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
