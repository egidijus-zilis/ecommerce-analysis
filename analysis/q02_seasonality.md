# Q2. How seasonal is demand?

**Question:** How seasonal is demand, overall and by category, and which months should inventory and campaign planning be built around?

**Expected:**
- November and December have the most sales (Black Friday, Christmas).
- January has the lowest sales.
- Garden sells most in spring and summer.
- Sports & Outdoors sells more from mid spring.

**Result:**

The main year is 2025. 2024 is left out: it was the first year, and orders grew from 62 in January to 342 in December, so growth hides the season. 2026 has data only until September, so it is used to check if the pattern repeats.

Orders and units by month:

| Month | Orders 2025 | Orders 2026 | Units 2025 | Units 2026 |
|---|---|---|---|---|
| Jan | 290 | 388 | 564 | 736 |
| Feb | 244 | 274 | 459 | 520 |
| Mar | 321 | 389 | 616 | 727 |
| Apr | 313 | 401 | 633 | 760 |
| May | 357 | 392 | 691 | 748 |
| Jun | 304 | 341 | 560 | 628 |
| Jul | 318 | 400 | 577 | 727 |
| Aug | 319 | 411 | 567 | 764 |
| Sep | 360 | 376 | 696 | 700 |
| Oct | 342 | - | 662 | - |
| **Nov** | **526** | - | **1006** | - |
| Dec | 450 | - | 836 | - |

- November is the busiest month. December is second.
- February is the quietest month in both years.
- In 2025 summer was a bit lower than May and September. In 2026 it was not.
- People buy about 2 items per order in every month, in both years. In busy months more people buy, but not more items each.

Units by category (2025):

| Category | Busiest months | Quiet months |
|---|---|---|
| Home & Kitchen | Nov, Dec (also Sep-Oct) | - |
| Beauty & Care | Nov, Dec | - |
| Fashion | Nov, Dec | - |
| Electronics | Nov, Dec | - |
| Toys & Kids | Dec, Nov | - |
| Sports & Outdoors | Apr, May | Feb, Nov, Dec |
| Garden | May, Apr | Jan, Feb, Dec |
| Pets | small changes, a bit more in Nov | - |

<details>
<summary>Full table: units by month and category (2025)</summary>

| Month | Fashion | Home & Kitchen | Beauty & Care | Sports & Outdoors | Electronics | Toys & Kids | Pets | Garden | Total |
|---|---|---|---|---|---|---|---|---|---|
| Jan | 129 | 130 | 82 | 70 | 59 | 46 | 41 | 7 | 564 |
| Feb | 97 | 104 | 81 | 49 | 47 | 26 | 44 | 11 | 459 |
| Mar | 103 | 95 | 109 | 89 | 77 | 41 | 48 | 54 | 616 |
| Apr | 92 | 106 | 91 | 113 | 65 | 37 | 50 | 79 | 633 |
| May | 99 | 88 | 103 | 112 | 72 | 57 | 42 | 118 | 691 |
| Jun | 95 | 107 | 88 | 74 | 43 | 54 | 38 | 61 | 560 |
| Jul | 107 | 91 | 89 | 97 | 50 | 39 | 42 | 62 | 577 |
| Aug | 113 | 94 | 81 | 76 | 69 | 41 | 61 | 32 | 567 |
| Sep | 123 | 149 | 94 | 82 | 86 | 54 | 66 | 42 | 696 |
| Oct | 111 | 161 | 122 | 70 | 78 | 38 | 59 | 23 | 662 |
| Nov | 187 | 261 | 177 | 63 | 125 | 92 | 74 | 27 | 1006 |
| Dec | 133 | 217 | 146 | 61 | 98 | 107 | 59 | 15 | 836 |

</details>

2026 (Jan-Sep) shows the same: Garden and Sports sell most in spring, February is quiet. Other categories change from year to year. Nov-Dec 2026 is not known yet.

<details>
<summary>Check: units by month and category (2026, Jan-Sep)</summary>

| Month | Fashion | Home & Kitchen | Beauty & Care | Sports & Outdoors | Electronics | Toys & Kids | Pets | Garden | Total |
|---|---|---|---|---|---|---|---|---|---|
| Jan | 173 | 201 | 139 | 59 | 54 | 43 | 54 | 13 | 736 |
| Feb | 92 | 124 | 114 | 48 | 52 | 33 | 49 | 8 | 520 |
| Mar | 124 | 161 | 154 | 80 | 71 | 41 | 54 | 42 | 727 |
| Apr | 130 | 138 | 128 | 109 | 61 | 58 | 65 | 71 | 760 |
| May | 104 | 109 | 114 | 123 | 76 | 66 | 56 | 100 | 748 |
| Jun | 117 | 116 | 84 | 84 | 61 | 56 | 43 | 67 | 628 |
| Jul | 137 | 114 | 122 | 113 | 80 | 54 | 44 | 63 | 727 |
| Aug | 157 | 133 | 116 | 88 | 77 | 86 | 52 | 55 | 764 |
| Sep | 136 | 160 | 114 | 80 | 57 | 55 | 58 | 40 | 700 |

</details>

**Expected vs result:**
- November and December have the most sales: **yes.**
- January has the lowest sales: **no.** February is the lowest, even per day (8.7 orders per day vs 9.4 in January). Probably because people already spent money on holidays, and January still has after-Christmas sales.
- Garden sells most in spring and summer: **yes.** Most in May, still good in June-July.
- Sports & Outdoors sells more from mid spring: **yes.** Most in April-May.

**So what:**
- There are two main seasons:
  - **Spring (April-May):** Garden and Sports. Have stock ready in March.
  - **November-December:** Home & Kitchen, Beauty, Electronics, Fashion, Toys. Have stock ready in October.
- Black Friday is the main campaign. Toys sell best in December.
- In November there are about 1.6 times more orders than in a normal month. Baskets are not bigger, so the shop needs more people for packing and delivery.
- February is quiet. Good time for small campaigns or other work.

**Limitations:**
- Only one full year (2025) can show the season. 2024 was the launch year, and 2026 has no data for October-December yet.
- I looked at units, not revenue. Many cheap items can make a month look bigger than it is in euros.