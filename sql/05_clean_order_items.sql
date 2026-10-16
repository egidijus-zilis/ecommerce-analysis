DROP TABLE IF EXISTS clean.order_items;

CREATE TABLE clean.order_items AS
SELECT
    order_item_id,
    order_id,
    product_id,
    CASE
        WHEN order_item_id IN (9633, 9702, 9962) THEN 1
        ELSE quantity
    END AS quantity,           -- DQ-12
    unit_price,
    discount_pct,
    is_returned,
    CASE
        WHEN is_returned = 1 AND return_reason IS NULL THEN 'not_provided'
        ELSE return_reason
    END AS return_reason,      -- DQ-11
    return_date,
    CASE
        WHEN unit_price = 0 THEN 1
        ELSE 0
    END AS is_zero_price       -- DQ-13
FROM raw.order_items
WHERE order_id NOT IN (2, 3, 8);   -- DQ-10


-- checks: raw

SELECT *
FROM raw.order_items
WHERE unit_price = 0.01;

SELECT *
FROM raw.order_items
WHERE return_reason IS NULL AND is_returned = 1;

SELECT *
FROM raw.order_items
WHERE order_id IN (5516, 5558, 5708) AND quantity >= 10;

SELECT *
FROM raw.order_items
WHERE unit_price = 0;

SELECT *
FROM raw.orders
WHERE order_id = 1240;

SELECT *
FROM raw.products
WHERE product_id IN (223, 259);


-- checks: clean

SELECT COUNT(*)
FROM clean.order_items;

SELECT *
FROM clean.order_items
WHERE order_id IN (2, 3, 8);

SELECT *
FROM clean.order_items
WHERE return_reason IS NULL AND is_returned = 1;

SELECT *
FROM clean.order_items
WHERE order_id IN (5516, 5558, 5708) AND quantity >= 10;

SELECT *
FROM clean.order_items
WHERE is_zero_price = 1;