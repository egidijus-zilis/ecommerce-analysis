# Q1. Is the business growing profitably?

**Question:** Is the business growing profitably? How do net revenue, gross profit and order volume change month over month and year over year, and how much of the change comes from new customers, repeat customers and order value?

**SQL:** `sql/q01_growth.sql`

**Expected** (written before SQL):
- November and December have the most sales (Black Friday, Christmas). Summer has less.
- The profit margin (profit / revenue) stays about the same every year.

## Answer

**Is the business growing profitably? Yes.** Revenue and gross profit grow every year, and the gross margin stays about the same (38-40 %). After marketing spend, profit also grows (+19.8 % in 2026), and the margin after marketing stays about the same (22-24 %).

1. Month over month: revenue, gross profit and orders are lowest in February and highest in November (2024 is different, because it was the launch year and grew almost every month). Margin is lower in November.
2. Year over year: the shop grows every year, but slower: +133 % in 2025, +20 % in 2026.
3. Where the growth comes from: in 2025 more orders brought 74,439 € and bigger orders 14,653 € (plus 14,103 € from both together). In 2026 almost all growth came from more orders (34,880 € of 35,360 €), and 90 % of it came from returning customers.

Expected: November and December have the most sales - **yes** (November first, December second). Summer has less - **yes in 2025, mostly no in 2026** (only June was lower). Margin stays the same - **yes**.

## 1. How do sales change month over month?

Net revenue by month (€):

| Month | 2024 | 2025 | 2026 |
|---|---|---|---|
| Jan | 4,111 | 23,184 | 22,221 |
| Feb | 4,743 | 13,969 | 17,156 |
| Mar | 5,919 | 19,732 | 20,855 |
| Apr | 8,087 | 20,875 | 25,741 |
| May | 8,801 | 22,228 | 26,621 |
| Jun | 8,977 | 18,017 | 23,750 |
| Jul | 10,042 | 18,512 | 26,725 |
| Aug | 11,477 | 18,462 | 26,603 |
| Sep | 15,184 | 25,555 | 26,223 |
| Oct | 16,010 | 22,108 | - |
| **Nov** | **28,083** | **34,341** | - |
| Dec | 20,224 | 30,549 | - |

- February is the weakest month in 2025 and 2026. November is the strongest month in 2024 and 2025, December is second (2026 has no November yet).
- In 2025 summer (June-August) was lower than May and September. In 2026 only June was lower.
- In 2026 the first months grew only a little (January-March about +6 % vs 2025, and January was even lower). April-August grew much more (about +32 %). September is not complete. Data was taken on 2026-10-01, and 32 orders from the last days of September are still 'shipped' or 'processing', so they are not counted yet. Right now September is about +2.6 % vs 2025. If none of these orders are cancelled or returned, it would be around +15.4 %.
- Gross profit and orders follow the same pattern: lowest in February (2025, 2026), highest in November (2024, 2025).
- Margin is lowest in January 2025 (33 %), November 2024 and 2025 (34 %) and July 2026 (35 %). Other months are 35-46 %.

<details>
<summary>Full table: gross profit, orders and margin by month</summary>

| Month | Gross profit (€) | Orders | Margin |
|---|---|---|---|
| 2024-01 | 1,880 | 62 | 45.7 % |
| 2024-02 | 1,918 | 95 | 40.5 % |
| 2024-03 | 2,478 | 118 | 41.9 % |
| 2024-04 | 3,166 | 152 | 39.1 % |
| 2024-05 | 3,311 | 171 | 37.6 % |
| 2024-06 | 3,829 | 178 | 42.6 % |
| 2024-07 | 3,793 | 211 | 37.8 % |
| 2024-08 | 4,436 | 201 | 38.6 % |
| 2024-09 | 5,793 | 252 | 38.2 % |
| 2024-10 | 6,857 | 260 | 42.8 % |
| 2024-11 | 9,579 | 395 | 34.1 % |
| 2024-12 | 7,919 | 342 | 39.2 % |
| 2025-01 | 7,666 | 290 | 33.1 % |
| 2025-02 | 5,924 | 244 | 42.4 % |
| 2025-03 | 7,988 | 321 | 40.5 % |
| 2025-04 | 8,239 | 313 | 39.5 % |
| 2025-05 | 8,763 | 357 | 39.4 % |
| 2025-06 | 7,623 | 304 | 42.3 % |
| 2025-07 | 6,997 | 318 | 37.8 % |
| 2025-08 | 6,961 | 319 | 37.7 % |
| 2025-09 | 9,337 | 360 | 36.5 % |
| 2025-10 | 8,762 | 342 | 39.6 % |
| 2025-11 | 11,736 | 526 | 34.2 % |
| 2025-12 | 10,764 | 450 | 35.2 % |
| 2026-01 | 8,606 | 388 | 38.7 % |
| 2026-02 | 6,823 | 274 | 39.8 % |
| 2026-03 | 9,220 | 389 | 44.2 % |
| 2026-04 | 10,852 | 401 | 42.2 % |
| 2026-05 | 10,021 | 392 | 37.6 % |
| 2026-06 | 9,026 | 341 | 38.0 % |
| 2026-07 | 9,316 | 400 | 34.9 % |
| 2026-08 | 10,548 | 411 | 39.6 % |
| 2026-09 | 9,982 | 376 | 38.1 % |

</details>

## 2. How do sales change year over year?

Same period every year (January-September):

| Year | Net revenue | Growth | Gross profit | Orders | Avg order value | Gross margin | Marketing spend | Gross profit after marketing | Margin after marketing |
|---|---|---|---|---|---|---|---|---|---|
| 2024 | 77,339 € | - | 30,604 € | 1,440 | 53.71 € | 39.6 % | 13,298 € | 17,306 € | 22.4 % |
| 2025 | 180,534 € | +133 % | 69,498 € | 2,826 | 63.88 € | 38.5 % | 26,829 € | 42,669 € | 23.6 % |
| 2026 | 215,895 € | +20 % | 84,394 € | 3,372 | 64.03 € | 39.1 % | 33,281 € | 51,113 € | 23.7 % |

Full years: 2024 - 141,656 €, 2025 - 267,533 €. Gross profit after marketing: 2024 - 31,501 €, 2025 - 60,100 €.

- Revenue, gross profit and orders grow every year. In 2025: revenue +133 %, gross profit +127 %, orders +96 %. In 2026: revenue +20 %, gross profit +21 %, orders +19 %.
- Marketing spend grows too: +24 % in 2026, a bit faster than gross profit (+21 %). Gross profit after marketing still grew: +147 % in 2025, +19.8 % in 2026. The margin after marketing stays about the same (22.4 %, 23.6 %, 23.7 %).
- Gross margin stays between 38.5 % and 39.6 % in all three years, so it stays about the same.

## 3. Where does the growth come from?

A new customer order is the person's first completed order. All later orders are returning customer orders (the same as in Q4).

Net revenue from new and returning customers (January-September):

| Year | New: customers | New: orders | New: net revenue | Returning: customers | Returning: orders | Returning: net revenue |
|---|---|---|---|---|---|---|
| 2024 | 1,208 | 1,208 | 65,428 € | 161 | 232 | 11,912 € |
| 2025 | 1,773 | 1,773 | 117,677 € | 673 | 1,053 | 62,858 € |
| 2026 | 1,847 | 1,847 | 121,282 € (+3 %) | 978 | 1,525 | 94,612 € (+51 %) |

- In 2026 revenue from new customers grew only 3 %, from returning customers 51 %.
- Returning customers brought 90 % of the growth in 2026 (31,755 € of 35,360 €).
- Avg order value grew in 2025 (54 € to 64 €), but in 2026 it stayed the same (see the table in part 2).

Growth split into more orders and bigger orders (January-September). Net revenue = orders × avg order value, so the change can be split into three parts that add up to the total:

| Year | Revenue change | More orders | Bigger orders | Both together |
|---|---|---|---|---|
| 2025 | +103,195 € | +74,439 € | +14,653 € | +14,103 € |
| 2026 | +35,360 € | +34,880 € | +402 € | +78 € |

- "More orders" = new orders × last year's avg order value. "Bigger orders" = last year's orders × the change in avg order value. "Both together" = new orders × the change in avg order value.
- In 2026, 99 % of the growth came from more orders. Bigger orders added only 402 €.

## Recommendations

1. **Keep returning customers buying.** In 2026, 90 % of the growth came from returning customers (978 people). The list of top customers who stopped buying is in [Q7](q07_best_customers.md). (part 3)
2. **Try to make orders bigger.** Order value stopped growing in 2026. For example, offer sets or "you may also like" products. (part 3)
3. **Plan for November.** It is the biggest month, so stock and staff must be ready. (part 1)

## Limitations

- 2026 has data only until September, so I compared January-September of every year.
- Profit uses today's product cost. Older costs are not known, so profit in 2024 may be a bit off.
- September 2026 is not complete (DQ-21). 32 orders from 2026-09-26 to 09-30 are still 'shipped' or 'processing', so they are not in net revenue yet. This makes September 2026 and January-September 2026 look lower than they will be. Right now January-September 2026 is +19.6 % vs 2025. If all open orders are completed and nothing is returned, it would be up to +21.4 %.
- Order 1240 is left out: its 2 lines were sold at 0 € (DQ-13).
- Gross profit after marketing is not net profit. Other costs (delivery, staff, rent) are not in the data.
- Marketing spend for 2025 is a bit too low: 3 days of paid_search are missing (DQ-17).
