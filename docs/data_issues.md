# Data issues log

| ID | Table.column | What is wrong | Rows affected | How found | Decision | Handled in |
|----|--------------|---------------|---------------|-----------|----------|------------|
| DQ-01 | customers (customer_id 1) | Looks like a test account: city "Test", signup_date 2023-12-28 (before the data period), no gender or birth_year | 1 | profile() date range, First look | to investigate | – |
| DQ-02 | customers.email_hash | Same email_hash used by more than one customer_id (possible duplicate accounts) | 56 (7,483 rows vs 7,427 unique) | profile() text check | to investigate | – |
| DQ-03 | customers.city | Same city written in different ways (case, extra spaces, with/without Lithuanian letters, e.g. Šiauliai / Siauliai) | 268 unique -> 164 after strip/lower | profile() text check | to investigate | – |
| DQ-04 | customers.city | City missing; field is not marked as optional in the data dictionary | 439 (5.87%) | profile() NULL check | to investigate | – |
| DQ-05 | customers.gender | Two encodings for the same values: F/M/X and Female/Male/Other | 1,297 Female/Male/Other vs 5,703 F/M/X | profile() value list | to investigate | – |
| DQ-06 | customers.birth_year | Impossible years: min 1900 (age 120+) and max 2026 (age 0) | to count | profile() min/max | to investigate | – |
| DQ-07 | products.unit_cost | unit_cost higher than list_price (e.g. product_id 1: 84.00 vs 19.99) | to count | First look | to investigate | – |
| DQ-08 | products.category | Inconsistent category labels: 'Electronics ' (trailing space) and 'Home and Kitchen' vs 'Home & Kitchen' | 3 | profile() value list | to investigate | – |
| DQ-09 | orders (all columns) | Fully duplicated rows: same order_id with identical values in all columns | 10 | profile() key and duplicate check | to investigate | – |
| DQ-10 | orders.order_total, order_items.unit_price | Orders with order_total 0.01 and order lines with unit_price 0.01, far below the cheapest product (orders 2, 3, 8 seen so far) | 3 orders | profile() min/max, nsmallest() | to investigate | – |
| DQ-11 | order_items.return_reason | Returned lines with no return reason | 94 | profile() NULL check | to investigate | – |
| DQ-12 | order_items.quantity | Possible outliers: max 15 while 99% of lines have 3 or fewer | to count | profile() min/max | to investigate | – |
| DQ-13 | order_items.unit_price | Lines sold at 0.00 with large quantities (order 1240: 12 and 10 units) | 2 | profile() min/max, nsmallest() | to investigate | – |
| DQ-14 | user_events.traffic_source | Traffic source missing (field not marked as optional in the data dictionary) | 11,944 events (1.98%) | profile() NULL check | to investigate | – |
| DQ-15 | user_events (purchase) vs orders.session_id | Purchase events (9,782) do not match orders with a session_id (9,675); cause unknown – could be extra purchase events or orders missing their session_id | 107 | profile() value list vs orders | to investigate | – |
| DQ-16 | marketing_spend (paid_social) | Fully duplicated rows (prospecting and retargeting have 1,006 rows instead of 1,004) | 4 | profile() key and duplicate check | to investigate | – |
| DQ-17 | marketing_spend (paid_search) | Missing days: brand and non_brand have 1,001 rows instead of 1,004 (one per day) | 6 rows (3 days × 2 campaign types) | profile() value list | to investigate | – |
| DQ-18 | orders.delivered_date | delivered_date is 1–2 days before the order date | 15 | Q3 check (order_date_local vs delivered_date) | to investigate | – |
