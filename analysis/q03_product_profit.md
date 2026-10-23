# Q3. Which products earn the most profit?

**Question:** Which categories and products earn the most and the least gross profit after discounts and returns, and which should we reprice, promote or drop?

**SQL:** `sql/q03_product_profit.sql`

**Period:** all data, 2024-01 to 2026-09. Products were on sale for a different number of months, so products are compared per month.

**Expected** (written before SQL):
- Home & Kitchen and Fashion earn the most profit.
- Garden earns the least.

## Answer

**Home & Kitchen and Fashion earn the most profit, Pets earns the least. No active product loses money, so no product needs to be dropped immediately.**

1. Most and least profit: Home & Kitchen and Fashion earn almost the same, together about half of all profit. Pets earns the least. The best product earns about 298 € per month, the weakest about 2 €.
2. Reprice, promote or drop: of the active products, 35 are in "keep", 73 in "reprice", 65 in "promote" and 58 in "review". 1 discontinued product did well before it was removed.

Expected: Home & Kitchen and Fashion earn the most profit - **yes**. Garden earns the least - **no**, Pets earns the least. Garden is sixth.

## 1. Which categories and products earn the most and the least?

Profit by category (all products):

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

Top 5 and bottom 5 active products by profit per month:

| id | Top 5 | Profit / month (EUR) | Margin | List price (EUR) | Group (part 2) |
|---|---|---|---|---|---|
| 232 | Urbana Canvas Backpack 20L | 298.16 | 59.4% | 49.99 | keep |
| 187 | Nordtek X3 5G Smartphone 256GB | 207.88 | 12.5% | 649.99 | keep |
| 230 | Baltix Robot Vacuum S6 | 194.69 | 22.1% | 229.99 | keep |
| 254 | Velora Women's Leather Crossbody Bag | 189.02 | 57.8% | 69.99 | keep |
| 176 | Nordtek AirBook 16 Laptop i7 16GB 1TB | 185.69 | 14.5% | 949.99 | promote |

| id | Bottom 5 | Profit / month (EUR) | Margin | List price (EUR) | Group (part 2) |
|---|---|---|---|---|---|
| 10 | Dermia Men's Face Moisturizer 75ml | 1.95 | 50.7% | 19.99 | review |
| 259 | Wonda Magnetic Drawing Board | 4.17 | 20.2% | 14.99 | review |
| 209 | Furro Orthopedic Dog Bed L | 4.36 | 37.5% | 79.99 | review |
| 216 | Lumiere Lab Citrus Homme Eau de Toilette 100ml | 5.28 | 40.4% | 54.99 | review |
| 127 | Whiskr Cat Tree 120cm | 5.47 | 51.9% | 74.99 | review |

- Price does not decide profit. Two of the top 5 products cost only 49.99 € and 69.99 €, and three of the bottom 5 cost more than 50 €. Profit depends on how often people buy and how much one sale earns.
- Margin % alone does not decide profit either. The smartphone and the laptop have a low margin (12-15 %), but they are in the top 5. Products 10 and 127 have a margin over 50 %, but they are in the bottom 5.

## 2. Which products should we reprice, promote or drop?

How the groups are made (two steps):
- Months on sale: from launch date (or 2024-01-01) to discontinued date (or 2026-09-30).
- **Step 1, ABC analysis.** Active products are sorted by profit per month. A = products that together make the first 80 % of profit, B = the next 15 %, C = the last 5 %. C products always go to "review".
- **Step 2, menu engineering.** A and B products are compared with the median of active products: 2.3 units per month and 13.43 € profit per unit.

| | Profit per unit ≥ 13.43 € | Profit per unit < 13.43 € |
|---|---|---|
| **Units per month ≥ 2.3** | keep | reprice |
| **Units per month < 2.3** | promote | review |

I first used margin % instead of profit per unit. But then expensive products with a low margin looked weak: the laptop, one of the top 5 products, was in "review". Profit per unit in euros fixes this. The ABC step was added because, without it, products that sell once in 4 months were in "promote".

Active products by ABC class:

| Class | Products | Gross profit (EUR) |
|---|---|---|
| A | 124 | 178,945 |
| B | 64 | 37,074 |
| C | 43 | 12,235 |
| no sales | 1 | - |

Active products by group:

| Group | Products | Gross profit (EUR) | Share of profit |
|---|---|---|---|
| keep | 35 | 64,961 | 28.5% |
| reprice | 73 | 75,726 | 33.2% |
| promote | 65 | 67,813 | 29.7% |
| review | 58 | 19,754 | 8.7% |

- No active product loses money, so no product is marked "drop". The weakest group is "review": 58 products bring only 8.7% of profit.
- 1 active product has no sales: Domus Steam Iron (id 239), launched on 2026-03-22.

**Top 5 reprice:** people buy them often, but each sale earns little. Sorted by units per month.

| id | Product | Category | Units / month | Profit / unit (EUR) | Profit / month (EUR) |
|---|---|---|---|---|---|
| 111 | Verdane Linen Cushion Cover 45x45 | Home & Kitchen | 13.52 | 8.91 | 120.43 |
| 98 | Petia Grain-Free Dog Treats 300g | Pets | 10.85 | 1.94 | 21.04 |
| 148 | Linea Women's High-Waist Leggings | Fashion | 10.85 | 11.44 | 124.14 |
| 242 | Lumea Scented Candle Amber 200g | Home & Kitchen | 10.49 | 8.38 | 87.91 |
| 134 | Greenly Garden Gloves 3-Pack | Garden | 9.37 | 5.30 | 49.62 |

**Top 5 promote:** each sale earns a lot, but people buy them rarely. Sorted by profit per unit.

| id | Product | Category | Units / month | Profit / unit (EUR) | Profit / month (EUR) |
|---|---|---|---|---|---|
| 176 | Nordtek AirBook 16 Laptop i7 16GB 1TB | Electronics | 1.36 | 136.16 | 185.69 |
| 237 | Peakline 4-Person Family Tent | Sports & Outdoors | 1.34 | 90.83 | 121.28 |
| 247 | Nordtek AirBook 14 Laptop i5 16GB 512GB | Electronics | 0.83 | 85.88 | 71.57 |
| 3 | Fjord Wear Men's Down Parka | Fashion | 0.58 | 77.61 | 44.70 |
| 81 | Hortus Garden Bench 120cm | Garden | 0.58 | 74.48 | 42.90 |

**Top 5 review:** earn the least per month. Sorted by profit per month, lowest first.

| id | Product | Category | Units / month | Profit / unit (EUR) | Profit / month (EUR) |
|---|---|---|---|---|---|
| 10 | Dermia Men's Face Moisturizer 75ml | Beauty & Care | 0.21 | 9.19 | 1.95 |
| 259 | Wonda Magnetic Drawing Board | Toys & Kids | 1.97 | 2.12 | 4.17 |
| 209 | Furro Orthopedic Dog Bed L | Pets | 0.23 | 19.38 | 4.36 |
| 216 | Lumiere Lab Citrus Homme Eau de Toilette 100ml | Beauty & Care | 0.24 | 22.24 | 5.28 |
| 127 | Whiskr Cat Tree 120cm | Pets | 0.15 | 36.09 | 5.47 |

**Discontinued products:** 28 products are not sold anymore. They have no ABC class, so only the step 2 rules are used. With these rules, 1 would be in "keep", 13 in "promote", 7 in "reprice" and 7 in "review".

| id | Product | Category | Removed | Units / month | Profit / unit (EUR) | Profit / month (EUR) |
|---|---|---|---|---|---|---|
| 164 | Casaro Wicker Storage Basket | Home & Kitchen | 2026-02-17 | 3.51 | 13.62 | 47.86 |

## Recommendations

1. **Improve the Electronics margin.** Electronics has the biggest revenue, but only 19.7% margin, so it earns less than Home & Kitchen and Fashion. Talk with suppliers about lower purchase prices and avoid big discounts on electronics. (part 1)
2. **Keep Home & Kitchen and Fashion always in stock.** Together they bring about half of all profit. Start campaigns for them only when the stock is ready. (part 1)
3. **Never let the top 5 products run out of stock.** Each of them earns 186-298 € per month. (part 1)
4. **Test a small price increase on the top 5 "reprice" products.** People buy them often, but each sale earns little. For example, Petia Grain-Free Dog Treats sell about 11 units per month, but earn only 1.94 € per unit. If sales stay the same, do the same for other "reprice" products. (part 2)
5. **Advertise the top 5 "promote" products more.** Each sale earns a lot (74-136 € per unit), but people buy them rarely. If sales grow, do the same for other "promote" products. (part 2)
6. **Stop ordering new stock for the 5 weakest "review" products and use this money for "keep" and "promote" products.** Together the 5 weakest products earn only about 21 € per month, so the same money can earn more on stronger products. Run this analysis again in a few months, because some "review" products can move to another group. (part 2)
7. **Consider bringing back Casaro Wicker Storage Basket.** Before it was removed, it sold 3.5 units per month and earned about 48 € per month. (part 2)

## Limitations

- `unit_cost` is today's cost, so profit is not exact. For discontinued products it is even less sure.
- Profit per unit makes expensive products look stronger. A cheap product with a high margin earns little per sale, so it can look weak.
- The ABC limits (80 %, 95 %) and the medians are common rules, not exact borders. Products close to a border can move to another group with a small change.
- New products have only a few months of data, so their numbers per month are less stable.
- The data does not show why a product was removed.
- The data has no stock or storage costs, so the gain from removing weak products can't be measured.
