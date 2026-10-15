SELECT 'customers' AS table_name, COUNT(*) AS rows FROM raw.customers
UNION ALL
SELECT 'products', COUNT(*) FROM raw.products
UNION ALL
SELECT 'orders', COUNT(*) FROM raw.orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM raw.order_items
UNION ALL
SELECT 'user_events', COUNT(*) FROM raw.user_events
UNION ALL
SELECT 'marketing_spend', COUNT(*) FROM raw.marketing_spend;