-- View: one row per customer (main_customer_id), completed orders only.
-- revenue_group: 1 = top 10% of customers by net revenue, 10 = bottom 10%.
-- main_customer_id breaks ties, so customers with the same revenue always get the same group.
DROP VIEW IF EXISTS analytics.customer_value;
CREATE VIEW analytics.customer_value AS
WITH customers_net_revenue AS (
SELECT
    main_customer_id,
    SUM(net_revenue) AS net_revenue,
    SUM(gross_profit) AS gross_profit,
    COUNT(*) AS orders,
    MIN(order_date_local) AS first_order_date,
    MAX(order_date_local) AS last_order_date
FROM analytics.orders_enriched
WHERE order_status = 'completed'
GROUP BY main_customer_id),
customer_groups AS (
SELECT
    main_customer_id,
    net_revenue,
    gross_profit,
    orders,
    first_order_date,
    last_order_date,
    NTILE(10) OVER (ORDER BY net_revenue DESC, main_customer_id) AS revenue_group
FROM customers_net_revenue)
SELECT
    cg.main_customer_id,
    cg.net_revenue,
    cg.gross_profit,
    cg.orders,
    cg.revenue_group,
    cg.first_order_date,
    cg.last_order_date,
    c.country,
    c.city,
    c.gender,
    c.birth_year,
    c.acquisition_source
FROM customer_groups cg
LEFT JOIN clean.customers c ON c.customer_id = cg.main_customer_id;
