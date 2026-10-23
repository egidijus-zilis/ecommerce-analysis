# Q2. How seasonal is demand?

**Question:** How seasonal is demand, overall and by category, and which months should inventory and campaign planning be built around?

**SQL:** `sql/q02_seasonality.sql`

**Period:** the main year is 2025. 2024 is left out: it was the first year, and orders grew from 62 in January to 342 in December, so growth hides the season. 2026 has data only until September, so it is used to check if the pattern repeats.

**Expected** (written before SQL):
- November and December have the most sales (Black Friday, Christmas).
- January has the lowest sales.
- Garden sells most in spring and summer.
- Sports & Outdoors sells more from mid spring.

## Answer

**How seasonal is demand? Quite seasonal.** In November there are about 1.5 times more orders than in an average month, and February is the quietest month.

1. Overall: November is the busiest month, December is second, February is the quietest. People buy about 2 items per order in every month.
2. By category: Garden and Sports & Outdoors sell most in April-May. Home & Kitchen, Beauty & Care, Fashion, Electronics and Toys & Kids sell most in November-December. Pets changes little.
3. Months to plan around: April-May (spring season), November-December (Black Friday and Christmas) and February (quiet month).

Expected: November and December have the most sales - **yes**. January has the lowest sales - **no**, February is the lowest. Garden sells most in spring and summer - **yes**, most in May. Sports & Outdoors sells more from mid spring - **yes**, most in April-May.

## 1. How seasonal is demand overall?

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

- November is the busiest month (about 1.5 times more orders than an average month). December is second.
- February is the quietest month in both years, even per day (2025: 8.7 orders per day in February, 9.4 in January).
- In 2025 summer was a bit lower than May and September. In 2026 only June was lower.
- People buy about 2 items per order in every month, in both years. In busy months more people buy, but not more items each.

## 2. How seasonal is demand by category?

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

- In 2025 Garden and Sports & Outdoors sell most in April-May. All other categories, except Pets, sell most in November-December.
- 2026 (January-September) shows the same for Garden and Sports & Outdoors: both sell most in May. Other categories change from year to year.

## 3. Which months should planning be built around?

| Months | Why |
|---|---|
| April-May | Garden and Sports & Outdoors sell the most |
| November | The busiest month (Black Friday) |
| December | The second busiest month. Toys & Kids sell the most |
| February | The quietest month |

## Recommendations

1. **Have Garden and Sports & Outdoors stock ready in March.** They sell most in April-May. (part 2)
2. **Have stock for Home & Kitchen, Beauty & Care, Fashion, Electronics and Toys & Kids ready in October.** They sell most in November-December. (part 2)
3. **Make Black Friday the main campaign. Plan a Toys & Kids campaign for December.** (parts 1, 2)
4. **Plan more people for packing and delivery in November.** There are more orders, but baskets are not bigger. (part 1)
5. **Order less stock for February.** It is the quietest month, and a good time for stocktaking. (part 1)

## Limitations

- Only one full year (2025) can show the season. 2024 was the launch year, and 2026 has no data for October-December yet.
- I looked at units, not revenue. Many cheap items can make a month look bigger than it is in euros.
