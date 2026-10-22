# Q4. Are discounts worth it?

**Question:** Are discounts worth it? What do sale periods and coupons cost us, and do they bring more orders, new customers and customers who come back?

**Expected:**
- Discounts bring new customers, and later they spend more than the discount cost us.
- Average order value (AOV) is higher during sale periods than outside them.

**Result:**

Each completed order is put in one group:
- **coupon:** the order has a coupon code.
- **sale:** no coupon, but at least one item has a discount.
- **full_price:** no discount.

**What discounts cost** (all data, 2024-01 to 2026-09):

| Group | Orders | Given as discount (EUR) | Net revenue (EUR) | Gross profit (EUR) | Margin | Margin if no discount |
|---|---|---|---|---|---|---|
| full_price | 6,675 | 0 | 433,402 | 172,495 | 39.8% | 39.8% |
| coupon | 1,799 | 11,388 | 104,364 | 37,031 | 35.5% | - |
| sale | 1,480 | 14,004 | 87,318 | 30,386 | 34.8% | 43.8% |

- Discounts on kept items cost about 25,400 EUR.
- "Margin if no discount" adds the discount back. Sale orders have products with a higher margin, so the lower margin comes from the discount, not from the products. In sale orders the discount takes about 9 points of margin.

**Sale periods:** sale orders are high in July, November and January. I checked July, because it is not a busy season. In July 2025 the sale ran from 07-01 to 07-31. 2024 is left out (launch year).

| Month | Orders per day | New customers per day | AOV (EUR) | Margin |
|---|---|---|---|---|
| 2025-06 | 10.13 | 5.97 | 59.27 | 42.3% |
| **2025-07 (sale)** | **10.26** | **6.35** | **58.21** | **37.8%** |
| 2025-08 | 10.29 | 6.35 | 57.87 | 37.7% |
| 2026-06 | 11.37 | 6.13 | 69.65 | 38.0% |
| **2026-07 (sale)** | **12.90** | **6.77** | **66.81** | **34.9%** |
| 2026-08 | 13.26 | 7.13 | 64.73 | 39.7% |

In July there are not more orders or new customers than in June and August. AOV is not higher either.

**Share of first orders** (the customer's first order with us):

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

WELCOME10 is used almost only on first orders, so it looks like a coupon for every new customer. This means the high share does not show that the coupon brought these customers.

**Do customers come back?** Customers are grouped by the type of their first order:

| First order | Customers | Bought again | Return rate |
|---|---|---|---|
| full_price | 3,758 | 1,162 | 30.9% |
| sale | 930 | 279 | 30.0% |
| coupon | 1,619 | 417 | 25.8% |

Customers who started with a coupon come back less.

**Expected vs result:**
- Discounts bring new customers, and later they spend more than the discount cost us: **no.** The July sale did not bring more new customers. Customers who start with a coupon come back less often than others. I did not check how much they spend later.
- AOV is higher during sale periods: **no.** July AOV is between June and August.

**So what:**
- **July sale:** costs margin, but brings no more orders and no more new customers.
- **WELCOME10:** customers who start with it come back less than customers who start without a discount.
- **AFF10:** almost all orders are first orders, so partners bring new customers.
- **EMAIL15:** used almost only by customers who already bought before (4 of 170 are first orders).

**Limitations:**
- Only the July sale was checked for extra orders. In November and January the sale and the busy season happen at the same time, so they can't be separated.
- We don't know what would happen without the sale.
- In coupon orders, a 15% line can be a sale or EMAIL15. These lines are counted as coupon. 34 lines have a smaller discount than the coupon, and the data does not explain why.
- What the coupons are for (welcome, email, partners) is guessed from their names. It is not written in the data.
- Return rate shows only if a customer bought again, not how much they spent.
