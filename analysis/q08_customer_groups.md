# Q8. Which customers bring the most value?

**Question:** Which countries (LT, LV, EE) and customer groups (city, age, gender) bring the most value per customer?

**SQL:** `sql/q08_customer_groups.sql`

**Period:** customers with the first order from 2025-01-01 to 2026-04-03. Completed orders only. A customer is one person (`main_customer_id`).

**Same time for everyone:** customers who started earlier had more time to buy, so a lifetime total makes older groups look better. So I count value only in the **first 180 days after the first order**. Only customers with the first order on or before 2026-04-03 had the full 180 days before the data ends. 2024 is left out, because it was the launch year with a lower order value (the same as in Q2).

**Value:** gross profit per customer in these 180 days. I want to know where we earn the most, so profit is better (the same as in Q7). Net revenue is shown next to it.

**Mean and median:** I show both. A few big customers pull the mean up (in Q7 the top 10% brought 40.37% of net revenue), so the median shows a typical customer better.

**Age groups:** age = 2026 - birth_year. Groups: 18-24, 25-34, 35-44, 45-54, 55-64, 65+. These are common marketing groups (Meta and Google use the same). Customers with no birth year go to "unknown" (most of them left it empty, some had impossible years, DQ-06).

**Expected** (written before SQL):
- Value per customer is not highest in Lithuania. LT has many customers, but many of them bring small profit.
- Customers aged 25-34 bring the most profit per customer.
- Men bring more profit per customer than women.

## Answer

**Countries, cities and age groups bring a similar value per customer in the first 180 days (31-33 € gross profit by country). Men spend more than women and buy different products: more Electronics, so their margin is lower.**

1. Countries: LT customers bring 32.92 € each (median 22.58 €), EE 32.29 € (median 21.30 €), LV 30.73 € (median 21.00 €).
2. Cities: by mean Tallinn (36.11 €), Šiauliai (35.90 €) and Panevėžys (35.32 €) are on top, Klaipėda (28.31 €) is the lowest. By median all cities are between 20.83 € and 25.52 €.
3. Age: all groups are between 30.63 € and 35.14 €. 45-54 is first by mean, 25-34 is second.
4. Gender: men spend more than women (101.04 € vs 74.61 €), but the profit is closer (34.64 € vs 31.12 €). By median they are about the same (22.33 € vs 22.45 €). Men's margin is 34.29%, women's 41.70%.

Expected:
- Value is not highest in Lithuania - **no**, LT is first, but only a little (32.92 € vs 32.29 € in EE and 30.73 € in LV).
- 25-34 brings the most - **no**, 45-54 is first by mean (35.14 €), 25-34 is second (32.91 €). The differences are small.
- Men bring more profit - **yes** by mean (34.64 € vs 31.12 €), **no** by median (22.33 € vs 22.45 €).

## 1. Which country brings the most value per customer?

| Country | Customers | Net revenue per customer (EUR) | Median net revenue (EUR) | Profit per customer (EUR) | Median profit (EUR) |
|---|---|---|---|---|---|
| LT | 2,499 | 86.72 | 51.98 | 32.92 | 22.58 |
| EE | 287 | 94.41 | 49.49 | 32.29 | 21.30 |
| LV | 381 | 78.58 | 47.99 | 30.73 | 21.00 |

- LT is first by mean and by median, but the three countries are close: 30.73-32.92 € by mean, 21.00-22.58 € by median.
- LT has the most customers (2,499), but a LT customer is not much more valuable than a LV or EE customer.

## 2. Which cities bring the most value per customer?

Only cities with 100+ customers. Smaller cities have only a few customers, and they can jump to the top by chance. 167 customers have no city, so they are not in this table.

| City | Customers | Net revenue per customer (EUR) | Median net revenue (EUR) | Profit per customer (EUR) | Median profit (EUR) |
|---|---|---|---|---|---|
| Tallinn | 166 | 113.52 | 52.08 | 36.11 | 25.52 |
| Šiauliai | 107 | 96.22 | 52.98 | 35.90 | 23.73 |
| Panevėžys | 101 | 92.44 | 54.88 | 35.32 | 24.98 |
| Kaunas | 458 | 88.17 | 56.58 | 33.92 | 24.67 |
| Vilnius | 985 | 86.57 | 52.27 | 33.07 | 22.57 |
| Rīga | 249 | 86.42 | 51.28 | 32.03 | 21.78 |
| Klaipėda | 215 | 72.37 | 49.48 | 28.31 | 20.83 |

- By mean, Tallinn, Šiauliai and Panevėžys are on top (35-36 €), Klaipėda is the lowest (28.31 €).
- By median, all cities are between 20.83 € and 25.52 €.
- Šiauliai (107) and Panevėžys (101) have only about 100 customers, so a few big customers can move the mean. I don't read much into the order.

## 3. Which age groups bring the most value per customer?

| Age group | Customers | Net revenue per customer (EUR) | Median net revenue (EUR) | Profit per customer (EUR) | Median profit (EUR) |
|---|---|---|---|---|---|
| 18-24 | 172 | 85.24 | 46.49 | 31.42 | 19.53 |
| 25-34 | 731 | 89.97 | 52.68 | 32.91 | 23.35 |
| 35-44 | 901 | 80.57 | 49.99 | 31.30 | 21.41 |
| 45-54 | 587 | 89.04 | 52.98 | 35.14 | 23.02 |
| 55-64 | 260 | 87.16 | 48.73 | 31.04 | 21.34 |
| 65+ | 82 | 74.27 | 40.73 | 30.63 | 18.34 |
| unknown | 434 | 91.50 | 54.94 | 33.09 | 23.57 |

- 45-54 is first by mean (35.14 €), 25-34 is second (32.91 €). By median, 25-34 (23.35 €) is first of the known age groups.
- All groups are between 30.63 € and 35.14 €. A difference of a few euros can come from a few big customers.
- Age does not really decide how much a customer brings.

## 4. Do men or women bring more value per customer?

| Gender | Customers | Net revenue per customer (EUR) | Median net revenue (EUR) | Profit per customer (EUR) | Median profit (EUR) | Margin |
|---|---|---|---|---|---|---|
| Male | 1,306 | 101.04 | 54.68 | 34.64 | 22.33 | 34.29% |
| Unknown | 221 | 88.29 | 49.48 | 32.10 | 21.47 | 36.35% |
| Female | 1,607 | 74.61 | 50.38 | 31.12 | 22.45 | 41.70% |
| Other | 33 | 72.26 | 46.98 | 26.97 | 19.39 | 37.32% |

- Men spend much more (101.04 € vs 74.61 €), but the profit is closer (34.64 € vs 31.12 €). Their margin is lower: 34.29% vs 41.70%.
- By median, men and women bring about the same profit (22.33 € vs 22.45 €).
- "Other" has only 33 customers, so its numbers are not reliable.

Why men's margin is lower, by category (share of each group's spending in the same 180 days):

| Category | Men | Women |
|---|---|---|
| Electronics | 40.49% | 16.92% |
| Home & Kitchen | 16.06% | 23.97% |
| Sports & Outdoors | 14.22% | 8.26% |
| Fashion | 12.39% | 19.31% |
| Garden | 5.94% | 5.83% |
| Toys & Kids | 4.83% | 6.88% |
| Pets | 3.37% | 3.32% |
| Beauty & Care | 2.71% | 15.50% |

- Men spend 40.49% of their money on Electronics, women only 16.92%. Electronics has the lowest margin (19.7%, Q3).
- Women spend more on Home & Kitchen, Fashion and Beauty & Care, which have higher margins.

## Recommendations

1. **Don't split offers by country, city or age: the value per customer is close. But ads can show different products to men and women,** because they buy different things (Electronics 40.49% vs 16.92%, Beauty & Care 2.71% vs 15.50%). Test it first. (parts 1-4)
2. **Start tracking marketing spend by country.** `marketing_spend` has no country, so now it is not possible to say in which country growing would pay off. (part 1)

## Limitations

- Value is counted only in the first 180 days. Customers who come back slowly, but for a long time, are not fully counted.
- Customers with the first order after 2026-04-03 are not in the analysis, because they did not have 180 days yet. 2024 customers are left out (launch year).
- Some groups are small (cities with about 100 customers, "Other" gender 33). I did not run a statistical test, so small differences can be just chance.
- The city table has only cities with 100+ customers. For LV and EE only the capitals are left.
- 167 customers have no city and 434 have no birth year. They are not in the city table and are "unknown" in the age table.
- Age is counted by year only (2026 - birth_year), so it can be 1 year off.
- The category table uses order lines, so the totals are a bit different from order totals (DQ-20).
- Marketing spend has no country, so value per customer can't be compared with the cost per customer in each country.
