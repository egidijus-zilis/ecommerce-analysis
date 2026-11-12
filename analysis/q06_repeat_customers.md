# Q6. Do customers buy again?

**Question:** What share of customers buy again and how soon? Do newer cohorts come back more or less than older ones?

**SQL:** `sql/q06_repeat_customers.sql`

**Period:** all data, 2024-01 to 2026-09. Completed orders only. A customer is one person (`main_customer_id`).

**Cohort:** a group of customers who made their first order in the same quarter.

**90-day window:** customers who joined late had little time to come back. So for fair comparison I also count who came back **within 90 days** of the first order. Only customers with a first order before 2026-07-01 are used, so everyone had at least 90 days.

**Expected** (written before SQL):
- About 25% of customers buy again.
- Newer and older cohorts come back about the same.

## Answer

**About 3 in 10 customers buy again, and half of them come back within about 2.5 months. Newer cohorts come back about as often as older ones.**

1. Share that buys again: 29.46% of all customers bought again. Within 90 days: 16.40%.
2. How soon: the median time to the second order is 79 days. 53.44% of returning customers come back within 90 days, 72.39% within 180 days.
3. Newer vs older cohorts: from 2024 Q3, every cohort returns at about the same rate, 15-19% within 90 days. Only the first two cohorts (launch period) are lower.

Expected: About 25% of customers buy again - **partly**, it is a bit more (29.46%). Newer and older cohorts come back about the same - **yes**.

## 1. What share of customers buy again?

| | Customers | Bought again | Share |
|---|---|---|---|
| All customers | 6,306 | 1,858 | 29.46% |
| Within 90 days (first order before 2026-07-01) | 5,683 | 932 | 16.40% |

- The real share is higher than 29.46%. Customers who made their first order in the last months had little time to come back before the data ends.
- The 90-day share is lower, because it counts only quick returns. It is used to compare cohorts in part 3.

## 2. How soon do they buy again?

Time from the first to the second order (only customers who bought again):

| Median | Average | Back within 90 days | Back within 180 days |
|---|---|---|---|
| 79 days | 147 days | 53.44% | 72.39% |

- Half of returning customers come back within 79 days.
- The average is much higher than the median, because some customers come back after a very long time.
- 28% of returning customers come back after more than 180 days.

## 3. Do newer cohorts come back more or less than older ones?

Share of customers who came back within 90 days, by cohort:

| Cohort | Customers | Back within 90 days | Share |
|---|---|---|---|
| 2024 Q1 | 260 | 28 | 10.77% |
| 2024 Q2 | 430 | 63 | 14.65% |
| 2024 Q3 | 518 | 97 | 18.73% |
| 2024 Q4 | 704 | 123 | 17.47% |
| 2025 Q1 | 565 | 104 | 18.41% |
| 2025 Q2 | 611 | 98 | 16.04% |
| 2025 Q3 | 597 | 91 | 15.24% |
| 2025 Q4 | 774 | 133 | 17.18% |
| 2026 Q1 | 596 | 99 | 16.61% |
| 2026 Q2 | 628 | 96 | 15.29% |

- From 2024 Q3, all cohorts are between 15% and 19%. Newer cohorts are not better or worse than older ones.
- The first two cohorts (2024 Q1 and Q2) are lower. This was the launch period, when the shop had few customers.

## Recommendations

1. **Send a reminder email to one-time customers 60 days after their first order.** Half of returning customers come back within 79 days, so the email comes just before the usual return time. It can include a small discount code, for example 5%. (part 2)
2. **Test it first on a part of the customers.** Split one-time customers into three groups: no email, email without a code, and email with a 5% code. After 90 days, compare how many came back in each group. This shows if the email works, and if the code is needed at all (in Q4, customers who started with a coupon came back less often). (parts 1, 2)

## Limitations

- The 90-day window catches only about half of all returns (53.44%). Customers who come back later are not part of the cohort comparison.
- The median (79 days) can be a bit too low. For new customers we only see quick returns, because slow returns happen after the data ends.
- "Bought again" means any second completed order. How much customers spend later is not measured.
