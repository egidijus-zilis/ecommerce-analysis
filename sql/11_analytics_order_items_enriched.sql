DROP VIEW IF EXISTS analytics.order_items_enriched;

CREATE VIEW analytics.order_items_enriched AS (
SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    p.product_name,
    p.category,
    oe.main_customer_id,
    oe.order_date_local,
    oe.order_status,
    oi.quantity,
    oi.unit_price,
    oi.discount_pct,
    oi.is_returned,
    p.unit_cost,
    CASE WHEN oe.order_status = 'completed'
         THEN ROUND(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0), 2)
         ELSE 0 END AS gross_revenue,         
    CASE WHEN oe.order_status = 'completed' AND oi.is_returned = 0
         THEN ROUND(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0), 2)
         ELSE 0 END AS net_revenue,
    CASE WHEN oe.order_status = 'completed' AND oi.is_returned = 0
         THEN oi.quantity * p.unit_cost
         ELSE 0 END AS cost,         
    CASE WHEN oe.order_status = 'completed' AND oi.is_returned = 0
         THEN ROUND(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0), 2) - oi.quantity * p.unit_cost
         ELSE 0 END AS gross_profit
FROM clean.order_items oi
LEFT JOIN analytics.orders_enriched oe ON oi.order_id = oe.order_id
LEFT JOIN clean.products p             ON oi.product_id = p.product_id
);