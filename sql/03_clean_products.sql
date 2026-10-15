DROP TABLE IF EXISTS clean.products;

CREATE TABLE clean.products AS
SELECT
    product_id,
    product_name,
    CASE
        WHEN category = 'Electronics ' THEN 'Electronics'
        WHEN category = 'Home and Kitchen' THEN 'Home & Kitchen'
        ELSE category
    END AS category,      -- DQ-08
    subcategory,
    brand,
    list_price,
    CASE
        WHEN product_id IN (1, 242) THEN unit_cost / 10
        ELSE unit_cost
    END AS unit_cost,     -- DQ-07
    launch_date,
    discontinued_date
FROM raw.products;


-- checks: raw

SELECT * FROM raw.products
WHERE unit_cost > list_price;

SELECT ROUND(AVG(unit_cost / list_price), 2)
FROM raw.products
WHERE category = 'Home & Kitchen' AND unit_cost < list_price;

SELECT MIN(unit_cost / list_price), MAX(unit_cost / list_price)
FROM raw.products
WHERE category = 'Home & Kitchen' AND unit_cost < list_price;

SELECT * FROM raw.products
WHERE category IN ('Electronics ', 'Home and Kitchen');


-- checks: clean

SELECT * FROM clean.products
WHERE unit_cost > list_price;

SELECT DISTINCT category FROM clean.products;

SELECT product_id, unit_cost FROM clean.products
WHERE product_id IN (1, 242);