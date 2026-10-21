# Q3. Which products earn the most profit?

**Question:** Which categories and products earn the most and the least gross profit after discounts and returns, and which should we reprice, promote or drop?

**Expected:**
- Home & Kitchen and Fashion earn the most profit.
- Garden earns the least.

**Result:**

Profit by category (all products, 2024-01 to 2026-09):

| Category | Products | Net revenue (EUR) | Gross profit (EUR) | Margin |
|---|---|---|---|---|
| Home & Kitchen | 45 | 125,558 | 57,605 | 45.9% |
| Fashion | 50 | 100,142 | 57,535 | 57.5% |
| Electronics | 30 | 172,877 | 34,003 | 19.7% |
| Sports & Outdoors | 35 | 74,366 | 27,191 | 36.6% |
| Beauty & Care | 35 | 53,638 | 25,314 | 47.2% |
| Garden | 20 | 38,292 | 15,785 | 41.2% |
| Toys & Kids | 25 | 38,622 | 15,055 | 39.0% |
| Pets | 20 | 21,755 | 7,591 | 34.9% |

- Home & Kitchen and Fashion earn almost the same. Together it is about half of all profit.
- Electronics has the biggest revenue, but the lowest margin, so it is only third by profit.
- Pets earns the least.

**Product groups:**

Products were on sale for a different number of months, so I compare them per month:
- Months on sale: from launch date (or 2024-01-01) to discontinued date (or 2026-09-30).
- Each product is compared with the median of active products: 2.3 units per month and 45.46% margin.

| | Margin above median | Margin below median |
|---|---|---|
| **Sells above median** | keep | reprice |
| **Sells below median** | promote | review |

No active product loses money, so no product is marked "drop". The weakest group is "review".

Active products by group:

| Group | Products | Gross profit (EUR) | Share of profit |
|---|---|---|---|
| keep | 60 | 82,441 | 36.1% |
| reprice | 56 | 61,386 | 26.9% |
| promote | 56 | 46,304 | 20.3% |
| review | 59 | 38,123 | 16.7% |

1 active product has no sales: Domus Steam Iron (id 239), launched on 2026-03-22.

**Top 5 reprice:** people buy them often, but the margin is low. Sorted by units per month.

| id | Product | Category | Units / month | Margin | Profit / month (EUR) |
|---|---|---|---|---|---|
| 98 | Petia Grain-Free Dog Treats 300g | Pets | 10.85 | 23.8% | 21.04 |
| 33 | Zenit Buds Lite Wireless Earbuds | Electronics | 7.88 | 25.7% | 63.23 |
| 59 | Silka Repair Shampoo 300ml | Beauty & Care | 7.37 | 35.7% | 25.48 |
| 17 | Fitora Jump Rope with Counter | Sports & Outdoors | 6.91 | 40.2% | 30.69 |
| 64 | Naturo Lavender Bath Salts 500g | Beauty & Care | 6.70 | 44.9% | 29.19 |

**Top 5 promote:** high margin, but people buy them rarely. Sorted by margin.

| id | Product | Category | Units / month | Margin | Profit / month (EUR) |
|---|---|---|---|---|---|
| 65 | Kopa Men's Chino Trousers | Fashion | 2.27 | 69.4% | 38.33 |
| 49 | Velora Women's Leather Gloves | Fashion | 2.03 | 66.7% | 49.72 |
| 101 | Fjord Wear Men's Flannel Shirt | Fashion | 0.82 | 66.2% | 14.28 |
| 18 | Urbana Men's Leather Wallet | Fashion | 1.36 | 65.3% | 27.62 |
| 28 | Fjord Wear Men's Oxford Shirt | Fashion | 1.91 | 62.0% | 28.33 |

**Top 5 review:** low sales and low margin. Sorted by profit per month, lowest first.

| id | Product | Category | Units / month | Margin | Profit / month (EUR) |
|---|---|---|---|---|---|
| 259 | Wonda Magnetic Drawing Board | Toys & Kids | 1.97 | 20.2% | 4.17 |
| 209 | Furro Orthopedic Dog Bed L | Pets | 0.23 | 37.5% | 4.36 |
| 216 | Lumiere Lab Citrus Homme Eau de Toilette 100ml | Beauty & Care | 0.24 | 40.4% | 5.28 |
| 27 | Baltix Smart Plug Wi-Fi 2-Pack | Electronics | 1.49 | 20.9% | 8.06 |
| 151 | Rovena USB Rechargeable Bike Light Set | Sports & Outdoors | 1.36 | 27.0% | 8.40 |

**Discontinued products:**

28 products are not sold anymore. With the same medians, 3 of them would be in "keep":

| id | Product | Category | Removed | Units / month | Margin | Profit / month (EUR) |
|---|---|---|---|---|---|---|
| 136 | Kopa Cotton Socks 5-Pack | Fashion | 2025-03-01 | 9.44 | 74.3% | 71.68 |
| 164 | Casaro Wicker Storage Basket | Home & Kitchen | 2026-02-17 | 3.51 | 51.5% | 47.86 |
| 140 | Aurelo Braided USB-C Cable 2m | Electronics | 2025-12-16 | 7.06 | 54.8% | 36.01 |

**Expected vs result:**
- Home & Kitchen and Fashion earn the most profit: **yes.**
- Garden earns the least: **no.** Pets earns the least. Garden is sixth.

**So what:**
- **Keep:** the most important products (36% of profit). Always have them in stock, no big discounts.
- **Reprice:** people buy them often, so a small price increase gives more profit. Test it on the top 5 and watch if sales drop.
- **Promote:** all top 5 are Fashion with 62-69% margin. Show them more in campaigns and newsletters.
- **Review:** this group still brings 16.7% of profit, so don't remove all of it. Check the weakest ones one by one. For example, products 209 and 216 sell about one unit in 4 months.
- **Discontinued:** check why these 3 products were removed. If there was no strong reason, bring them back.
- **Domus Steam Iron (239):** never sold. Check the product page, price and stock.

**Limitations:**
- `unit_cost` is today's cost, so margin is not exact. For discontinued products it is even less sure.
- Products close to the median can move to another group with a small change (for example, product 64 has 44.9% margin, the median is 45.46%).
- New products have only a few months of data, so their numbers per month are less stable.
- The data does not show why a product was removed.
