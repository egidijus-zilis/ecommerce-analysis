# Q7. How much do we depend on our best customers?

**Question:** How much revenue depends on our best customers, what do they have in common, and how much revenue is at risk if they stop buying?

**SQL:** `sql/q07_best_customers.sql`

**Period:** all data, 2024-01 to 2026-09. Completed orders only. A customer is one person (`main_customer_id`).

**Best customers:** I sorted all customers by net revenue and split them into 10 groups of the same size. Group 1 is the top 10% (631 customers), and these are the best customers here.

**Expected** (written before SQL):
- The top 10% of customers bring about 35% of all net revenue.

## Answer

**We depend on them a lot. The top 10% bring 43.26% of net revenue, but only 34.77% of gross profit. 190 of them are at risk now, and they bring about 62,400 € per year.**

1. How much depends on them: 43.26% of revenue and 34.77% of profit. Profit share is lower because their margin is only 30.87%.
2. What they have in common: they order more often (3.47 orders each) and spend more per order (123.37 €). Almost half of their money goes to Electronics. More of them came from referral and email. Country is about the same as for other customers.
3. Revenue at risk: 190 top customers (30.11%) have not ordered for longer than usual. Together they bring 62,395 € per year. 182 more have not ordered for over a year, so I count them as lost.

Expected: The top 10% bring about 35% of net revenue - **no**, it is more, 43.26%.

## 1. How much revenue depends on our best customers?

| Group | Customers | Net revenue (EUR) | Share of revenue | Gross profit (EUR) | Share of profit | Margin | Orders per customer | AOV (EUR) |
|---|---|---|---|---|---|---|---|---|
| 1 (top 10%) | 631 | 270,437 | 43.26% | 83,478 | 34.77% | 30.87% | 3.47 | 123.37 |
| 2 | 631 | 104,554 | 16.73% | 44,686 | 18.61% | 42.74% | 2.18 | 76.04 |
| 3 | 631 | 70,372 | 11.26% | 31,472 | 13.11% | 44.72% | 1.78 | 62.78 |
| 4 | 631 | 52,059 | 8.33% | 22,871 | 9.53% | 43.93% | 1.52 | 54.34 |
| 5 | 631 | 40,338 | 6.45% | 18,019 | 7.50% | 44.67% | 1.33 | 48.08 |
| 6 | 631 | 31,312 | 5.01% | 14,247 | 5.93% | 45.50% | 1.21 | 41.04 |
| 7 | 630 | 23,054 | 3.69% | 10,233 | 4.26% | 44.39% | 1.15 | 31.71 |
| 8 | 630 | 17,057 | 2.73% | 7,743 | 3.22% | 45.39% | 1.06 | 25.57 |
| 9 | 630 | 11,241 | 1.80% | 5,275 | 2.20% | 46.93% | 1.05 | 16.93 |
| 10 | 630 | 4,658 | 0.75% | 2,089 | 0.87% | 44.84% | 1.03 | 7.20 |

- The top 10% bring more revenue (43.26%) than groups 2, 3 and 4 together (36.32%).
- In profit the picture is different. Their share drops to 34.77%, because their margin is 30.87%. Other groups have 43-47%.

## 2. What do best customers have in common?

How they buy (from the table in part 1):
- Top customers made 3.47 orders each. Group 2 made 2.18, and group 10 only 1.03.
- Their AOV is 123.37 €, group 2 has 76.04 €.

What they buy (share of each group's spending by category):

| Category | Top 10% | Other 90% |
|---|---|---|
| Electronics | 48.79% | 11.53% |
| Home & Kitchen | 15.32% | 23.71% |
| Fashion | 10.40% | 20.30% |
| Sports & Outdoors | 9.37% | 13.82% |
| Garden | 5.25% | 6.79% |
| Beauty & Care | 4.57% | 11.64% |
| Toys & Kids | 3.87% | 7.93% |
| Pets | 2.43% | 4.28% |

- Almost half of top customers' money goes to Electronics. Other customers spend only 11.53% there.
- Electronics has the lowest margin of all categories (19.7%, see Q3). That explains why top customers bring less profit than revenue in part 1.

Where they came from (acquisition channel):

| Channel | Top 10% | Other 90% | Channel customers in top 10% |
|---|---|---|---|
| organic_search | 27.42% | 28.16% | 9.77% |
| paid_search | 15.85% | 17.85% | 8.98% |
| direct | 15.53% | 14.45% | 10.68% |
| paid_social | 14.90% | 18.56% | 8.20% |
| referral | 13.95% | 8.14% | 16.00% |
| email | 7.61% | 5.15% | 14.12% |
| affiliate | 4.75% | 7.70% | 6.42% |

- Referral (16.00%) and email (14.12%) bring more top customers than other channels.
- Affiliate (6.42%) and paid_social (8.20%) bring fewer.

Country:

| Country | Top 10% | Other 90% |
|---|---|---|
| LT | 83.84% | 79.89% |
| LV | 8.40% | 11.26% |
| EE | 7.77% | 8.85% |

- The split is almost the same as for other customers.

## 3. How much revenue is at risk if they stop buying?

First I needed to know how often top customers usually order. For each customer with 2+ orders I took the average gap between orders:

| Top customers | With 2+ orders | Median gap | Average gap |
|---|---|---|---|
| 631 | 465 | 88.7 days | 122.5 days |

My first idea was "at risk = no order in the last quarter". But the median gap is already about 89 days, so many customers would be at risk just because they buy at their normal pace. So I used each customer's own gap:

- Risk limit: 2 x the customer's average gap, but not less than 90 and not more than 180 days. Customers with only 1 order have no gap, so they get 180 days.
- active: last order is within the risk limit.
- at risk: over the risk limit, but not more than 365 days.
- lost: no order for more than 365 days. I added this group because at first many at-risk customers had not ordered for a very long time.
- Revenue per year: net revenue / years since the first order. Every customer counts as at least 1 year, so one big order from a new customer doesn't look like a full year of spending.

Status on 2026-09-30 (last day of data):

| Status | Customers | Share | 1 order | 2 orders | 3+ orders | Revenue per year (EUR) | Share of revenue per year | Profit per year (EUR) |
|---|---|---|---|---|---|---|---|---|
| active | 259 | 41.05% | 53 | 40 | 166 | 88,342 | 44.81% | 27,119 |
| at risk | 190 | 30.11% | 33 | 50 | 107 | 62,395 | 31.65% | 18,659 |
| lost | 182 | 28.84% | 80 | 38 | 64 | 46,402 | 23.54% | 12,582 |

- 190 top customers are at risk. If they don't come back, we lose about 62,395 € revenue and 18,659 € profit per year.
- 182 are already lost, and 80 of them made only 1 order.
- Customers with more orders get lost less often: 48% of 1-order customers (80 of 166), 30% of 2-order customers (38 of 128) and 19% of 3+ order customers (64 of 337).

## Recommendations

1. **Contact top customers as soon as they become at risk.** 190 of them bring 62,395 € per year, and the email can be tested on half of them first to see if it brings them back. (part 3)
2. **Give a reward for inviting a friend (referral).** 16.00% of referral customers become top customers, while only 6.42% of affiliate customers do. (part 2)
3. **Offer accessories with Electronics orders.** Top customers spend 48.79% on Electronics, where the margin is only 19.7%, so an accessory with a higher margin raises the profit of the order. (parts 1, 2)

## Limitations

- I chose best customers by revenue, not by profit. Someone who buys mostly Electronics can be in the top 10% and still bring less profit.
- Revenue per year is based on past spending. It is not a forecast, and some at-risk customers will come back without any action.
- The risk limit (90-180 days) and the 365 days for lost are my own rules. Other limits would change the groups.
- Customers with 2 orders have only one gap, so their risk limit is less reliable.
- Counting every customer as at least 1 year is also my choice. A customer who joined less than a year ago may still buy more this year, so their revenue per year can be too low.
- The category table uses order lines, so the total is 166 € higher than in part 1 (42 € for top customers). This comes from 24 orders with manual compensations (DQ-20).
- The acquisition channel is taken from the customer's main account.
