DROP TABLE IF EXISTS clean.customers;

CREATE TABLE clean.customers AS
SELECT
    c.customer_id,
    FIRST_VALUE(c.customer_id) OVER (
        PARTITION BY c.email_hash
        ORDER BY c.signup_date, c.customer_id
    ) AS main_customer_id,                                          -- DQ-02
    c.email_hash,
    c.signup_date,
    c.country,
    COALESCE(m.city, INITCAP(TRIM(c.city)), 'Unknown') AS city,     -- DQ-03, DQ-04
    CASE
        WHEN c.gender = 'F'   THEN 'Female'
        WHEN c.gender = 'M'   THEN 'Male'
        WHEN c.gender = 'X'   THEN 'Other'
        WHEN c.gender IS NULL THEN 'Unknown'
        ELSE c.gender
    END AS gender,                                                  -- DQ-05
    CASE
        WHEN c.birth_year = 1900 OR c.birth_year >= 2024 THEN NULL
        ELSE c.birth_year
    END AS birth_year,                                              -- DQ-06
    c.acquisition_source,
    c.marketing_opt_in
FROM raw.customers c
LEFT JOIN clean.city_map m ON INITCAP(TRIM(c.city)) = m.raw_city   -- needs sql/08_city_map.sql
WHERE c.customer_id <> 1;                                           -- DQ-01


-- checks: raw

-- DQ-02: accounts with the same email_hash and their number of orders
SELECT c.customer_id, c.email_hash, c.signup_date, COUNT(o.order_id) AS orders
FROM raw.customers c
LEFT JOIN clean.orders o ON c.customer_id = o.customer_id
WHERE c.email_hash IN (
    SELECT email_hash
    FROM raw.customers
    GROUP BY email_hash
    HAVING COUNT(*) > 1)
GROUP BY c.customer_id, c.email_hash, c.signup_date
ORDER BY c.email_hash, c.signup_date;

-- DQ-03: city variants after TRIM and INITCAP
SELECT INITCAP(TRIM(city)), COUNT(*)
FROM raw.customers
GROUP BY INITCAP(TRIM(city))
ORDER BY 1;

-- DQ-05: gender values
SELECT gender, COUNT(*)
FROM raw.customers
GROUP BY gender;

-- DQ-06: birth_year values
SELECT birth_year, COUNT(*)
FROM raw.customers
GROUP BY birth_year
ORDER BY birth_year;


-- checks: clean

SELECT COUNT(*) FROM clean.customers;                           -- 7482

SELECT COUNT(DISTINCT main_customer_id) FROM clean.customers;   -- 7426

SELECT city, COUNT(*) FROM clean.customers
GROUP BY city ORDER BY city;                                    -- 71 (70 cities + Unknown)

SELECT r.city AS raw_city, c.city AS clean_city, COUNT(*)       -- city before and after
FROM raw.customers r
JOIN clean.customers c ON r.customer_id = c.customer_id
WHERE r.city IS DISTINCT FROM c.city
GROUP BY r.city, c.city
ORDER BY c.city;

SELECT gender, COUNT(*) FROM clean.customers
GROUP BY gender;                                                -- 4 values

SELECT MIN(birth_year), MAX(birth_year) FROM clean.customers;   -- 1946, 2008