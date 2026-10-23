# Q4. Are discounts worth it?

**Question:** Are discounts worth it? What do sale periods and coupons cost us, and do they bring more orders, new customers and customers who come back?

**SQL:** `sql/q04_discounts.sql`

**Period:** all data, 2024-01 to 2026-09. For the July sale check, 2024 is left out (launch year).

**Order groups:** each completed order is put in one group:
- **coupon:** the order has a coupon code.
- **sale:** no coupon, but at least one item has a discount.
- **full_price:** no discount.

**Expected** (written before SQL):
- Discounts bring new customers, and later they spend more than the discount cost us.
- Average order value (AOV) is higher during sale periods than outside them.

## Answer

**Are discounts worth it? Mostly no.** Discounts cost about 25,400 € and lower the margin. The July sale does not bring more orders or new customers, and customers who start with a coupon come back less often.

1. Cost: discounts cost about 25,400 €. The discount takes about 9 points of margin in sale orders and about 6 points in coupon orders.
2. More orders: no. July (sale) is between June and August, so there is no extra jump in orders.
3. New customers: the July sale does not bring a jump in new customers. 90% of coupon orders are first orders, but WELCOME10 is given to every new customer, so this does not show that the coupon brought them.
4. Customers who come back: customers who start with a sale come back as often as others (30.0% vs 30.9%). Customers who start with a coupon come back less often (25.8%).

Expected: Discounts bring new customers, and later they spend more than the discount cost us - **no**. New customers did not jump in July, and coupon customers come back less often. How much they spend later was not checked. AOV is higher during sale periods - **no**, July AOV is between June and August.

## 1. What do sale periods and coupons cost us?

| Group | Orders | Given as discount (EUR) | Net revenue (EUR) | Gross profit (EUR) | Margin | Margin if no discount |
|---|---|---|---|---|---|---|
| full_price | 6,675 | 0 | 433,402 | 172,495 | 39.8% | 39.8% |
| coupon | 1,799 | 11,388 | 104,364 | 37,031 | 35.5% | 41.8% |
| sale | 1,480 | 14,004 | 87,318 | 30,386 | 34.8% | 43.8% |

- Discounts on kept items cost about 25,400 €.
- "Margin if no discount" adds the discount back. Sale and coupon orders have products with a higher margin than full price orders, so the lower margin comes from the discount, not from the products. The discount takes about 9 points of margin in sale orders (43.8% → 34.8%) and about 6 points in coupon orders (41.8% → 35.5%).

## 2. Do discounts bring more orders?

Share of sale orders by month (months with the most sale orders):

| Month | Sale orders | Share of all orders |
|---|---|---|
| 2024-07 | 113 | 53.6% |
| 2024-11 | 99 | 25.1% |
| 2025-01 | 117 | 40.3% |
| 2025-07 | 109 | 34.3% |
| 2025-11 | 171 | 32.5% |
| 2026-01 | 151 | 38.9% |
| 2026-07 | 136 | 34.0% |

- Sales happen in July, November and January. In other months sale orders are 0-18% of all orders.
- In July 2025 the sale ran from 07-01 to 07-31 (daily data).
- July is used to check the effect, because it is not a busy season. In November and January the sale and the busy season happen at the same time.

July sale vs June and August:

| Month | Orders per day | New customers per day | AOV (EUR) | Margin |
|---|---|---|---|---|
| 2025-06 | 10.13 | 5.97 | 59.27 | 42.3% |
| **2025-07 (sale)** | **10.26** | **6.35** | **58.21** | **37.8%** |
| 2025-08 | 10.29 | 6.35 | 57.87 | 37.7% |
| 2026-06 | 11.37 | 6.13 | 69.65 | 38.0% |
| **2026-07 (sale)** | **12.90** | **6.77** | **66.81** | **34.9%** |
| 2026-08 | 13.26 | 7.13 | 64.73 | 39.7% |

- July is between June and August in orders per day and in AOV. In these months the business grows month by month, so July follows this growth. There is no extra jump from the sale.

## 3. Do discounts bring new customers?

- **Sale: no.** New customers per day in July are between June and August, so there is no extra jump (table in part 2).
- **Coupons: the data can't show it.** Most coupon orders are first orders, but this is because of how the coupons are given, not proof that they bring new customers (see below).

Share of first orders (the customer's first order with us):

| Group | Orders | First orders | Share |
|---|---|---|---|
| coupon | 1,799 | 1,619 | 90.0% |
| sale | 1,480 | 930 | 62.8% |
| full_price | 6,675 | 3,758 | 56.3% |

By coupon:

| Coupon | Orders | First orders |
|---|---|---|
| WELCOME10 | 1,457 | 1,444 |
| AFF10 | 172 | 171 |
| EMAIL15 | 170 | 4 |

- Sale orders have a bit more first orders than full price orders (62.8% vs 56.3%). This does not mean that the sale brings new customers: new customers per day do not jump in July. New customers come anyway, and during a sale they simply buy discounted products.
- WELCOME10 is used almost only on first orders, so it looks like a coupon for every new customer. AFF10 is also used almost only on first orders, but we can't tell if these customers would come without the partner. EMAIL15 is used almost only by customers who already bought before.

## 4. Do discounts bring customers who come back?

Customers grouped by the type of their first order:

| First order | Customers | Bought again | Return rate |
|---|---|---|---|
| full_price | 3,758 | 1,162 | 30.9% |
| sale | 930 | 279 | 30.0% |
| coupon | 1,619 | 417 | 25.8% |

- Customers who started with a sale come back about as often as customers who paid full price.
- Customers who started with a coupon come back less often.

## Recommendations

1. **Test a smaller or shorter July sale.** The July sale lowers the margin, but brings no extra orders or new customers. We don't know what would happen without it, so a smaller sale next July can show if the same orders come with a better margin. (parts 1, 2)
2. **Test a coupon for the second order instead of only the first.** Customers who start with WELCOME10 come back less often (25.8% vs 30.9%). A second-order coupon costs margin again, but it can show if these customers start to come back. (part 4)

## Limitations

- Only the July sale was checked for extra orders. In November and January the sale and the busy season happen at the same time, so they can't be separated.
- Coupons are used all year, so there is no period without them to compare with. Extra orders from coupons can't be measured.
- We don't know what would happen without the sale.
- In coupon orders, a 15% line can be a sale or EMAIL15. These lines are counted as coupon. A few lines in coupon orders have a smaller discount than the coupon or no discount, and the data does not explain why.
- What the coupons are for (welcome, email, partners) is guessed from their names. It is not written in the data.
- Return rate shows only if a customer bought again, not how much they spent.
