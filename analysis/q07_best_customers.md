# Q7. How much do we depend on our best customers?

**Question:** How much revenue and gross profit depend on our best customers, what do they have in common, and how much gross profit could we win back from top customers who haven't ordered for longer than usual?

**SQL:** `sql/q07_best_customers.sql`

**Period:** all data, 2024-01 to 2026-09. Completed orders only. A customer is one person (`main_customer_id`).

**Best customers:** I sorted all customers by gross profit and split them into 10 groups of the same size. Group 1 is the top 10% (631 customers), and these are the best customers here. I chose gross profit, because profit is what the shop earns. A customer who buys a lot with a low margin is not the most valuable one.

**Expected** (written before SQL):
- The top 10% of customers bring about 35% of all net revenue.

## Answer

**We depend on them a lot. The top 10% bring 36.95% of gross profit and 40.37% of net revenue. 193 of them have not ordered for longer than usual, but winning them back is worth at most about 3,500 € gross profit per year (estimate).**

1. How much depends on them: 36.95% of profit and 40.37% of revenue. Even the most profitable customers have a lower margin (35.15%) than groups 2-9 (38.86-41.77%).
2. What they have in common: they order more often (3.72 orders each) and spend more per order (107.53 €). 39.60% of their money goes to Electronics. More of them came from referral and email. Country is about the same as for other customers.
3. Win-back: 193 top customers (30.59%) have not ordered for longer than usual. Last year, top customers in the same situation brought only 11.07 € gross profit each in the next 12 months, and active ones 29.45 €. So a win-back campaign could add at most about 3,500 € gross profit per year. This is an estimate, and the real number is likely lower. 178 more have not ordered for over a year, so I count them as lost.

Expected: The top 10% bring about 35% of net revenue - **no**, it is more, 40.37%.

## 1. How much revenue and gross profit depend on our best customers?

| Group | Customers | Net revenue (EUR) | Share of revenue | Gross profit (EUR) | Share of profit | Margin | Orders per customer | AOV (EUR) |
|---|---|---|---|---|---|---|---|---|
| 1 (top 10%) | 631 | 252,377 | 40.37% | 88,711 | 36.95% | 35.15% | 3.72 | 107.53 |
| 2 | 631 | 104,314 | 16.69% | 43,575 | 18.15% | 41.77% | 2.04 | 81.18 |
| 3 | 631 | 72,756 | 11.64% | 30,358 | 12.64% | 41.73% | 1.72 | 67.18 |
| 4 | 631 | 56,825 | 9.09% | 22,786 | 9.49% | 40.10% | 1.45 | 61.97 |
| 5 | 631 | 43,707 | 6.99% | 17,672 | 7.36% | 40.43% | 1.31 | 52.72 |
| 6 | 631 | 32,660 | 5.22% | 13,479 | 5.61% | 41.27% | 1.22 | 42.42 |
| 7 | 630 | 24,531 | 3.92% | 9,928 | 4.13% | 40.47% | 1.16 | 33.70 |
| 8 | 630 | 18,206 | 2.91% | 7,218 | 3.01% | 39.65% | 1.07 | 26.97 |
| 9 | 630 | 12,122 | 1.94% | 4,711 | 1.96% | 38.86% | 1.06 | 18.17 |
| 10 | 630 | 7,586 | 1.21% | 1,677 | 0.70% | 22.11% | 1.03 | 11.63 |

- The top 10% bring 36.95% of gross profit and 40.37% of net revenue.
- Even though I chose them by profit, their margin (35.15%) is lower than in groups 2-9 (38.86-41.77%). So they bring a lot of profit because they buy a lot, not because they buy high-margin products.

## 2. What do best customers have in common?

How they buy (from the table in part 1):
- Top customers made 3.72 orders each. Group 2 made 2.04, and group 10 only 1.03.
- Their AOV is 107.53 €, group 2 has 81.18 €.

What they buy (share of each group's spending by category):

| Category | Top 10% | Other 90% |
|---|---|---|
| Electronics | 39.60% | 19.56% |
| Home & Kitchen | 17.90% | 21.56% |
| Fashion | 14.32% | 17.17% |
| Sports & Outdoors | 10.06% | 13.14% |
| Beauty & Care | 5.93% | 10.37% |
| Garden | 5.47% | 6.56% |
| Toys & Kids | 4.20% | 7.52% |
| Pets | 2.52% | 4.13% |

- 39.60% of top customers' money goes to Electronics. Other customers spend 19.56% there.
- Electronics has the lowest margin of all categories (19.7%, see Q3). I think this is why top customers have a lower margin in part 1.

Where they came from (acquisition channel):

| Channel | Top 10% | Other 90% | Channel customers in top 10% |
|---|---|---|---|
| organic_search | 28.37% | 28.05% | 10.11% |
| paid_search | 16.16% | 17.81% | 9.16% |
| direct | 16.16% | 14.38% | 11.11% |
| paid_social | 14.10% | 18.64% | 7.76% |
| referral | 13.15% | 8.23% | 15.09% |
| email | 7.61% | 5.15% | 14.12% |
| affiliate | 4.44% | 7.74% | 6.00% |

- "Channel customers in top 10%" = share of the channel's customers who are in the top 10%. For all customers together it is 10%.
- Referral (15.09%) and email (14.12%) bring more top customers than other channels.
- Affiliate (6.00%) and paid_social (7.76%) bring fewer.

Country:

| Country | Top 10% | Other 90% |
|---|---|---|
| LT | 82.41% | 80.05% |
| LV | 8.87% | 11.21% |
| EE | 8.72% | 8.74% |

- The split is almost the same as for other customers.

## 3. How much gross profit could we win back?

First I needed to know how often top customers usually order. For each customer with 2+ orders I took the average gap between orders:

| Top customers | With 2+ orders | Median gap | Average gap |
|---|---|---|---|
| 631 | 511 | 89.3 days | 124.4 days |

My first idea was "at risk = no order in the last quarter". But the median gap is already about 89 days, so many customers would be at risk just because they buy at their normal pace. So I used each customer's own gap:

- Risk limit: 2 x the customer's average gap, but not less than 90 and not more than 180 days. Customers with only 1 order have no gap, so they get 180 days.
- active: last order is within the risk limit.
- at risk: over the risk limit, but not more than 365 days.
- lost: no order for more than 365 days. I added this group because at first many at-risk customers had not ordered for a very long time.

Status on 2026-09-30 (last day of data):

| Status | Customers | Share | 1 order | 2 orders | 3+ orders |
|---|---|---|---|---|---|
| active | 260 | 41.20% | 39 | 34 | 187 |
| at risk | 193 | 30.59% | 18 | 51 | 124 |
| lost | 178 | 28.21% | 63 | 46 | 69 |

- 193 top customers are at risk now.
- 178 are already lost, and 63 of them made only 1 order.

### What did such customers do before? (back-test)

I can't see what today's customers will do next. But I can see what similar customers did last year. So I pretended that today is 2025-09-30 and used only orders up to that date. I chose the top 10% and the status with the same rules as above. Then I looked at their real gross profit from 2025-10-01 to 2026-09-30.

| Status on 2025-09-30 | Customers | Bought in the next 12 months | Profit per year before (EUR) | Real profit in the next 12 months (EUR) | Profit per customer in the next 12 months (EUR) |
|---|---|---|---|---|---|
| active | 190 | 42.11% | 23,010 | 5,596 | 29.45 |
| at risk | 135 | 26.67% | 15,696 | 1,495 | 11.07 |
| lost | 44 | 15.91% | 3,333 | 265 | 6.02 |

- "Profit per year before" = all past gross profit / years as a customer (at least 1 year). This is the simple way to guess next year.
- The simple way would say that at-risk customers bring 15,696 € per year. In reality they brought 1,495 € in the next 12 months. So past spending per year is not a good guess for the future.
- Even active customers brought less than before (5,596 € vs 23,010 €). I think the reason is that top customers were chosen by high past profit, and many of them don't repeat it.
- Only 26.67% of at-risk customers bought anything in the next 12 months.

### What could a win-back add? (estimate)

I assume that today's 193 at-risk customers act like last year's at-risk customers.

| Scenario for the 193 at-risk customers | Gross profit in the next 12 months (EUR) |
|---|---|
| We do nothing (193 x 11.07 €) | 2,137 |
| All of them buy like active customers (193 x 29.45 €) | 5,684 |
| The most a win-back could add | 3,547 |

- This is an estimate, not a fact.
- 3,547 € is a ceiling. It assumes that every at-risk customer starts to buy like an active one. The real result will likely be lower.
- It is before the campaign cost. A campaign is worth it only if it brings more gross profit than it costs.
- I count only at-risk customers. Lost customers have not ordered for over a year, so I think it is even less likely that they would buy like active ones.

## Recommendations

1. **Try a cheap win-back email for at-risk top customers, and test it first.** 193 top customers have not ordered for longer than usual. Winning them back can add at most about 3,500 € gross profit per year (estimate), so the campaign must be cheap. Send it to half of them, and after 90 days compare gross profit with the other half. Give a discount only if the test shows that the extra profit is bigger than the discount cost. (part 3)
2. **Offer accessories with Electronics orders.** Top customers spend 39.60% on Electronics, where the margin is only 19.7%, so an accessory with a higher margin raises the profit of the order. (parts 1, 2)

## Limitations

- I chose best customers by gross profit. A customer who brings a lot of revenue with a low margin can be outside the top 10%.
- The win-back estimate is based on one back-test date (2025-09-30) and 135 at-risk customers. A few big buyers can move the average, and another date could give a different number.
- Today's top customers have a longer history (since 2024-01, 33 months) than the back-test customers (21 months), and the business grew. They may not act exactly like last year's customers.
- The difference between active and at-risk customers is not the effect of a campaign. Active customers can be different people. Only a test with a group that gets no email can show the real effect.
- The back-test uses today's data for past orders. Returns made after 2025-09-30 are already taken out of the past net revenue, so a few customers can be in a different group than they were on that day.
- The next 12 months include September 2026, which is not complete (DQ-21). So the real profit in the back-test can be a bit too low.
- The risk limit (90-180 days) and the 365 days for lost are my own rules. Other limits would change the groups.
- Customers with 2 orders have only one gap, so their risk limit is less reliable.
- Counting every customer as at least 1 year in "profit per year before" is my choice. It is used only to compare with the real profit.
- The category table uses order lines, so the total is 166 € higher than in part 1 (42 € for top customers). This comes from 24 orders with manual compensations (DQ-20).
- The acquisition channel is taken from the customer's main account.
