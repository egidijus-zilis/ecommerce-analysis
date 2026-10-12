# E-commerce Analysis

A portfolio project where I check, clean and analyse data from an online store.
I made it while learning data analysis. I use it to practise the main parts of a data analyst's work:
checking data quality, writing SQL, and building a dashboard.

> **Note about the data:** the data is synthetic (made up). It was generated with the help of an AI tool
> for learning purposes. It follows realistic business rules, and it contains data quality problems on purpose,
> so they can be found and fixed. The store, products and customers are not real.

---

## Project status

| Stage | What | Status |
|---|---|---|
| 0 | Set up the repository and Python environment | Done |
| 1a | Profile each table in Python (find data problems) | Done |
| 1b | Check how the tables match each other (cross-table checks) | Planned |
| 2 | Load the data into PostgreSQL and clean it | Planned |
| 3 | Answer the business questions with SQL | Planned |
| 4 | Build a Power BI dashboard | Planned |
| 5 | Write up findings and recommendations | Planned |

---

## The business

A small online store based in Vilnius. It sells to customers in Lithuania, Latvia and Estonia.

- 260 products in 8 categories: Fashion, Home & Kitchen, Beauty & Care, Sports & Outdoors, Electronics, Toys & Kids, Pets, Garden
- Delivery: courier, parcel locker, or pickup at the Vilnius showroom
- Data period: **1 January 2024 – 30 September 2026**

---

## Data

| Table | One row is | Rows |
|---|---|---|
| customers | one customer account | 7,483 |
| products | one product | 260 |
| orders | one order | 10,269 |
| order_items | one product line in an order | 17,784 |
| user_events | one website event (product view, add to cart, purchase, ...) | 603,272 |
| marketing_spend | one day × channel × campaign type | 7,026 |

How the tables connect:

```
customers ──< orders ──< order_items >── products
                 │
            session_id
                 │
            user_events

marketing_spend: joined by date and channel
```

Good to know:
- Columns ending in `_ts` are times in **UTC**. Columns ending in `_date` are **local dates** (Vilnius time).
- `list_price` (products) is today's price. `unit_price` (order_items) is the price on the day of the sale.

All columns are described in [docs/data_dictionary.md](docs/data_dictionary.md).

---

## Tools

- **Python (pandas)** in Jupyter notebooks – data profiling
- **PostgreSQL** (with DBeaver) – data cleaning and analysis
- **Power BI** – dashboard
- **Git and GitHub** – version control

---

## Repository structure

```
ecommerce-analysis/
├── data/raw/                         original CSV files (never changed)
├── docs/
│   ├── data_dictionary.md            what each column means
│   └── data_issues.md                log of data problems found
├── notebooks/
│   └── 01_profiling.ipynb            checks each table on its own
├── sql/                              SQL files for cleaning and analysis (coming later)
├── powerbi/                          Power BI file and screenshots (coming later)
├── requirements.txt
└── README.md
```

---

## How I work

1. **Profile the data (Python).** I look at each table and write down problems. I do not fix anything in Python.
2. **Log every problem** in [docs/data_issues.md](docs/data_issues.md) with an ID (DQ-01, DQ-02, ...).
   Later each problem gets a decision: fix, remove, flag or keep.
3. **Clean the data (PostgreSQL).** The raw data stays as it is. All fixes are done in SQL, so they can be repeated.
   The database has three layers: `raw` → `clean` → `analytics` (views).
4. **Answer the business questions (SQL).** Each question has its own SQL file.
   Before running a query, I write down what I expect to see.
5. **Show the results (Power BI).** The dashboard uses the same SQL views, so the numbers match.

---

## Data quality: what I found so far

Profiling found **19 data problems**. The full list is in [docs/data_issues.md](docs/data_issues.md).
Here they are grouped by what they would break if not fixed:

| Area | Examples | Issues |
|---|---|---|
| Revenue, orders and products | duplicated orders, test orders, suspicious prices and quantities, cost 10× too high for 2 products, delivery before order | DQ-01, DQ-07 – DQ-13, DQ-18 |
| Customers | duplicate accounts, a test account, city written in many ways, two gender codes, impossible birth years | DQ-01 – DQ-06 |
| Web traffic and conversion | a bot, purchase events that don't match orders (cause not known yet), missing traffic source | DQ-14, DQ-15, DQ-19 |
| Marketing spend | 2 days counted twice, 3 days missing | DQ-16, DQ-17 |

Next step (notebook 02):
- Were products sold before their launch date or after they were discontinued?
- Do the large quantities match the order total?
- Why do purchase events not match orders?
- Does `order_total` equal the sum of order lines plus shipping fee?
- Is every return date after the delivery date?

---

## Business questions

These questions will be answered with SQL. **Not answered yet.**

**Growth and seasonality**
1. Is the business growing profitably? How do revenue, gross profit and order volume change month over month and year over year, and how much of the change comes from new customers, repeat customers and order value?
2. How seasonal is demand, overall and by category, and which months should inventory and campaign planning be built around?

**Profitability and products**

3. Which categories and products earn the most and the least gross profit after discounts and returns, and which should we reprice, promote or drop?
4. What do sale periods and coupons cost us in margin, and what do we get back in extra orders, new customers and repeat purchases?
5. Which products and categories are bought together, and where is there a bundle or cross-sell opportunity?

**Customers**

6. What share of customers buy again, how soon, and are newer cohorts retaining better or worse than earlier ones?
7. How much revenue depends on our best customers, what do they have in common, and how much revenue is at risk if they stop buying?
8. How do our markets (LT, LV, EE) and customer segments (city, age, gender) differ in customer value, and where should growth efforts focus?

**Acquisition and marketing**

9. Which acquisition channels bring customers worth keeping (repeat rate, revenue and gross profit per customer), not just sign-ups?
10. What does it cost to acquire a customer in each paid channel, how has that cost changed over time, and how long does it take to pay back?
11. Can we rely on ad platforms' reported conversions when allocating budget? How do they compare with the orders we can attribute to each channel ourselves?

**Conversion**

12. Where do shoppers drop out of the purchase funnel, and does it differ by device or traffic source?
13. How long do shoppers take from first product view to purchase, does it differ for new and returning customers, and what does that mean for remarketing timing?

**Operations**

14. How does delivery performance (on time vs late) relate to returns and repeat purchases, and does it differ by delivery method?
15. What do returns and cancellations cost us, where are they concentrated, and what are the main reasons?
16. How do order values relate to our shipping fees and free-shipping threshold, and are they set at the right level?

Each answer will have the same parts: question → what I expected → method (SQL file) → result → what it means → recommendation → limitations.

---

## Metric definitions

Will be written before the analysis starts. For example: revenue, gross profit, new vs returning customer, conversion rate, late delivery.

---

## Key findings

Coming after the analysis.

---

## Limitations

- The data is synthetic, so the findings describe a made-up store, not a real business.
- The analysis shows relationships in the data. It does not prove what causes what.

---

## How to run

```
git clone https://github.com/egidijus-zilis/ecommerce-analysis.git
cd ecommerce-analysis
python -m venv .venv
.venv\Scripts\activate          # Windows
pip install -r requirements.txt
```

Then open the notebooks in the `notebooks/` folder. The SQL and Power BI steps will be added later.

---

## Author

Egidijus Žilis – [LinkedIn](https://www.linkedin.com/in/egidijus-%C5%BEilis-a15134225/)