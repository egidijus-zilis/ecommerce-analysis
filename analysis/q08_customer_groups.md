# Q8. Which customers bring the most value?

**Question:** Which countries (LT, LV, EE) and customer groups (city, age, gender) bring the most value per customer? Where should we focus to grow?

**SQL:** `sql/q08_customer_groups.sql`

**Period:** all data, 2024-01 to 2026-09. Completed orders only. A customer is one person (`main_customer_id`).

**Value:** gross profit per customer. In Q7 I used net revenue, because that question was about revenue. Here I want to know where we earn the most, so profit is better. Net revenue is shown next to it.

**Mean and median:** I show both. A few big customers pull the mean up (in Q7 the top 10% brought 43% of revenue), so the median shows a typical customer better.

**Age groups:** age = 2026 - birth_year. Groups: 18-24, 25-34, 35-44, 45-54, 55-64, 65+. These are common marketing groups (Meta and Google use the same). Customers with no birth year go to "unknown" (most of them left it empty, some had impossible years, DQ-06).

**Expected** (written before SQL):
- Value per customer is not highest in Lithuania. LT has many customers, but many of them bring small profit.
- Customers aged 25-34 bring the most profit per customer.
- Men bring more profit per customer than women.

## Answer

**Lithuania brings the most value per customer, about 10% more than Latvia and Estonia. Between cities, age groups and gender the differences are small, so they are not a good way to choose where to focus.**

1. Countries: LT customers bring 38.82 € profit each (median 25.20 €), LV and EE about 35 €.
2. Cities: among cities with 100+ customers, Panevėžys (42.55 €) and Šiauliai (41.11 €) are on top, Alytus (32.15 €) is the lowest. Medians are close, 23-27 €, except Alytus (17.52 €).
3. Age: all groups are between 36.28 € and 39.05 €. 25-34 is first, but 45-54 is only 0.18 € lower.
4. Gender: men spend 28% more than women (113.66 € vs 88.60 €), but bring only 6% more profit (39.71 € vs 37.40 €). By median, women are a bit higher.
5. Where to focus: Lithuania. Who the customer is (city, age, gender) changes value very little. How they behave matters more: in Q7, 16.00% of referral customers became top customers, but only 6.42% of affiliate customers.

Expected:
- Value is not highest in Lithuania - **no**, it is highest in Lithuania.
- 25-34 brings the most - **yes**, but the difference with other groups is very small.
- Men bring more profit - **yes** by mean (39.71 € vs 37.40 €), **no** by median (24.57 € vs 25.35 €).

## 1. Which country brings the most value per customer?

| Country | Customers | Net revenue per customer (EUR) | Median net revenue (EUR) | Profit per customer (EUR) | Median profit (EUR) |
|---|---|---|---|---|---|
| LT | 5,063 | 100.93 | 57.46 | 38.82 | 25.20 |
| EE | 551 | 93.44 | 49.92 | 35.11 | 22.02 |
| LV | 692 | 90.46 | 52.98 | 35.01 | 23.42 |

- LT is first by mean and by median. A LT customer brings about 10% more profit than a LV or EE customer.
- LT also has 80% of all customers, so it is both the biggest and the most valuable market.
- LV and EE are almost the same.

## 2. Which cities bring the most value per customer?

Only cities with 100+ customers. Smaller cities had only a few customers, and they jumped to the top by chance (for example, Haapsalu with 2 customers). 365 customers have no city, so they are not in this table.

| City | Customers | Net revenue per customer (EUR) | Median net revenue (EUR) | Profit per customer (EUR) | Median profit (EUR) |
|---|---|---|---|---|---|
| Panevėžys | 207 | 108.95 | 58.97 | 42.55 | 26.31 |
| Šiauliai | 249 | 104.81 | 55.97 | 41.11 | 25.50 |
| Vilnius | 1,936 | 100.53 | 57.98 | 38.88 | 25.76 |
| Kaunas | 896 | 100.02 | 57.97 | 38.08 | 25.00 |
| Klaipėda | 423 | 98.06 | 59.99 | 37.50 | 26.51 |
| Tallinn | 325 | 102.09 | 49.49 | 36.88 | 23.08 |
| Rīga | 454 | 90.33 | 56.94 | 34.65 | 25.04 |
| Alytus | 118 | 74.63 | 43.47 | 32.15 | 17.52 |

- By mean, Panevėžys and Šiauliai are on top. By median, all cities except Alytus are between 23.08 € and 26.51 €.
- So the higher mean in Panevėžys and Šiauliai probably comes from a few big customers, not from all customers there.
- Alytus is lower by mean and by median.
- In every city the mean is 1.4-1.8 times the median. A few big customers pull the mean up everywhere.

## 3. Which age groups bring the most value per customer?

| Age group | Customers | Net revenue per customer (EUR) | Median net revenue (EUR) | Profit per customer (EUR) | Median profit (EUR) |
|---|---|---|---|---|---|
| 18-24 | 328 | 97.75 | 58.48 | 36.28 | 25.72 |
| 25-34 | 1,372 | 103.92 | 58.49 | 39.05 | 26.30 |
| 35-44 | 1,793 | 94.24 | 53.98 | 36.67 | 23.29 |
| 45-54 | 1,249 | 99.50 | 55.46 | 38.87 | 24.18 |
| 55-64 | 534 | 98.44 | 59.98 | 38.41 | 25.85 |
| 65+ | 171 | 93.70 | 55.47 | 37.95 | 24.10 |
| unknown | 859 | 103.15 | 56.98 | 38.79 | 25.35 |

- 25-34 is first by mean (39.05 €) and by median (26.30 €).
- But all groups are between 36.28 € and 39.05 €. A difference of a few euros can come from a few big customers.
- Age does not really decide how much a customer brings.

## 4. Do men or women bring more value per customer?

| Gender | Customers | Net revenue per customer (EUR) | Median net revenue (EUR) | Profit per customer (EUR) | Median profit (EUR) | Margin |
|---|---|---|---|---|---|---|
| Male | 2,605 | 113.66 | 58.48 | 39.71 | 24.57 | 34.94% |
| Female | 3,224 | 88.60 | 55.47 | 37.40 | 25.35 | 42.21% |
| Unknown | 400 | 94.55 | 54.93 | 34.64 | 22.82 | 36.64% |
| Other | 77 | 71.79 | 50.48 | 29.09 | 21.02 | 40.52% |

- Men spend much more (113.66 € vs 88.60 €), but the profit is almost the same (39.71 € vs 37.40 €). Their margin is lower: 34.94% vs 42.21%.
- By median, women bring a bit more profit (25.35 € vs 24.57 €).
- "Other" has only 77 customers, so its numbers are not reliable.

Why men's margin is lower, by category (share of each group's spending):

| Category | Men | Women |
|---|---|---|
| Electronics | 38.66% | 15.86% |
| Home & Kitchen | 16.23% | 24.22% |
| Sports & Outdoors | 14.90% | 8.84% |
| Fashion | 13.07% | 19.19% |
| Garden | 6.39% | 5.95% |
| Toys & Kids | 5.09% | 7.30% |
| Pets | 3.39% | 3.39% |
| Beauty & Care | 2.28% | 15.25% |

- Men spend 38.66% of their money on Electronics, women only 15.86%. Electronics has the lowest margin (19.7%, Q3).
- Women spend more on Home & Kitchen, Fashion and Beauty & Care, which have higher margins.

## Recommendations

1. **Keep most of the marketing budget in Lithuania.** It has 80% of customers and the highest profit per customer. (part 1)
2. **Don't split ads by city, age or gender.** The differences are only a few euros per customer. (parts 2-4)

## Limitations

- The differences between age groups and cities are small. I did not run a statistical test, so some of them can be just chance.
- The city table has only cities with 100+ customers. For LV and EE only the capitals are left.
- 365 customers have no city and 859 have no birth year. They are not in the city table and are "unknown" in the age table.
- Age is counted by year only (2026 - birth_year), so it can be 1 year off.
- "Other" gender has only 77 customers.
- The category table uses order lines, so the totals are a bit different from order totals (DQ-20).
