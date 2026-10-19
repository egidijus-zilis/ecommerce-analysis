DROP TABLE IF EXISTS clean.marketing_spend;

CREATE TABLE clean.marketing_spend AS
SELECT DISTINCT *              -- DQ-16
FROM raw.marketing_spend;
-- DQ-17: 3 missing days are kept as they are (no data to fill)


-- checks: raw

SELECT m, COUNT(*)
FROM raw.marketing_spend m
GROUP BY m
HAVING COUNT(*) > 1;

WITH no_dups AS (
    SELECT DISTINCT * FROM raw.marketing_spend
)
SELECT campaign_type, COUNT(*)
FROM no_dups
GROUP BY campaign_type;

WITH no_dups AS (
    SELECT DISTINCT * FROM raw.marketing_spend
)
SELECT spend_date, COUNT(*)
FROM no_dups
GROUP BY spend_date
ORDER BY COUNT(*);


-- checks: clean

SELECT COUNT(*)
FROM clean.marketing_spend;

SELECT m, COUNT(*)
FROM clean.marketing_spend m
GROUP BY m
HAVING COUNT(*) > 1;