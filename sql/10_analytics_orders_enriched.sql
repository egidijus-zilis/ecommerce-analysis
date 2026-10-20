CREATE SCHEMA IF NOT EXISTS analytics;

CREATE OR REPLACE VIEW analytics.orders_enriched AS
WITH items AS (
    SELECT oi.order_id,
        SUM(CASE
                WHEN oi.is_returned = 1 THEN ROUND(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0), 2)
                ELSE 0
            END) AS returned_value,
        SUM(CASE
                WHEN oi.is_returned = 0 THEN oi.quantity * p.unit_cost
                ELSE 0
            END) AS cost
    FROM clean.order_items oi
    LEFT JOIN clean.products p ON oi.product_id = p.product_id
    GROUP BY oi.order_id
)
SELECT
    o.order_id,
    o.customer_id,
    c.main_customer_id,
    o.order_ts,
    (o.order_ts AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Vilnius')::date AS order_date_local,
    o.status AS order_status,
    o.coupon_code,
    o.payment_method,
    o.delivery_method,
    o.promised_date,
    o.delivered_date,
    o.order_total,
    o.shipping_fee,
    i.returned_value,
    i.cost,
    CASE WHEN o.status = 'completed' THEN o.order_total - o.shipping_fee ELSE 0 END AS gross_revenue,
    CASE WHEN o.status = 'completed' THEN o.order_total - o.shipping_fee - i.returned_value ELSE 0 END AS net_revenue,
    CASE WHEN o.status = 'completed' THEN o.order_total - o.shipping_fee - i.returned_value - i.cost ELSE 0 END AS gross_profit,
    MIN(CASE WHEN o.status = 'completed' THEN o.order_ts END)
        OVER (PARTITION BY c.main_customer_id) AS first_order_ts,
    CASE
        WHEN o.order_ts = MIN(CASE WHEN o.status = 'completed' THEN o.order_ts END)
                              OVER (PARTITION BY c.main_customer_id)
        THEN 1 ELSE 0
    END AS is_first_order
FROM clean.orders o
LEFT JOIN items i ON o.order_id = i.order_id
LEFT JOIN clean.customers c ON o.customer_id = c.customer_id;


-- checks

-- same number of rows as clean.orders (10 256)
SELECT COUNT(*) FROM analytics.orders_enriched;

-- one first order per person who bought (both numbers must match)
SELECT COUNT(*) FROM analytics.orders_enriched WHERE is_first_order = 1;

SELECT COUNT(DISTINCT main_customer_id) FROM analytics.orders_enriched WHERE order_status = 'completed';

-- orders that are not completed have no profit (0)
SELECT SUM(gross_profit) FROM analytics.orders_enriched WHERE order_status <> 'completed';