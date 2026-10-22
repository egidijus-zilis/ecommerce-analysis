DROP VIEW IF EXISTS analytics.orders_discount;

CREATE VIEW analytics.orders_discount AS
WITH order_discount AS (
SELECT
    oe.order_id,
    MAX(oi.discount_pct) AS max_discount,
    SUM(oi.quantity * oi.unit_price * oi.discount_pct / 100.0) FILTER (WHERE oi.is_returned = 0) AS discount_eur
FROM analytics.orders_enriched oe
LEFT JOIN clean.order_items oi ON oe.order_id = oi.order_id
GROUP BY oe.order_id),
orders_typed AS (
SELECT
    oe.order_id,
    oe.main_customer_id,
    oe.order_date_local,
    oe.coupon_code,
    CASE
        WHEN oe.coupon_code IS NOT NULL THEN 'coupon'
        WHEN od.max_discount > 0 THEN 'sale'
        ELSE 'full_price'
    END AS what_discount,
    od.max_discount,
    ROUND(COALESCE(od.discount_eur, 0), 2) AS discount_eur,
    oe.net_revenue,
    oe.gross_profit,
    oe.is_first_order
FROM analytics.orders_enriched oe
LEFT JOIN order_discount od ON oe.order_id = od.order_id
WHERE oe.order_status = 'completed')
SELECT * FROM orders_typed;