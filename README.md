# E-commerce Analysis

Analysis of a synthetic Lithuanian online store dataset (Oct 2025 - Sep 2026)
using Python, SQL and Power BI.

> Note: the dataset was created using Claude and does not depict a real e-commerce shop.

## Dataset

5 related tables in `data/`: customers, products, orders, order_items, user_events.

## Business questions

**Sales and growth**

1. How do revenue, order count and average order value change month over month, and which of the three explains the growth?
2. How much does net revenue (after cancelled and returned orders) differ from gross revenue each month?

**Products and profit**

3. Which price bands (low, mid, high) drive revenue, and which drive profit?
4. Which categories earn high revenue but low margin, and how does the profit ranking differ from the revenue ranking?
5. Which products are most often bought together in one order?

**Returns**

6. How much revenue is lost to returns and cancellations, and is the loss concentrated in particular categories, channels or order sizes?

**Funnel and channels**

7. At which funnel stage does each channel lose the most users, and does the weak point differ between channels?
8. Is the November-December peak driven by more visitors or by better conversion?
9. Which channels bring the most valuable customers (revenue and profit per acquired customer), not just the most customers?
10. Based on revenue per visitor, which channel deserves more marketing budget?

**Customers**

11. How concentrated is revenue: what share comes from the top 10% of customers and the top 20% of products?
12. What share of customers make a second purchase, and how long after the first one?
13. How do customers split into segments by recency, frequency and spend, and which segment generates the most revenue?
14. How does retention differ between monthly signup cohorts?

## Tools

Python, SQL, Power BI

## Project structure

- `data/` - CSV files
- `notebooks/` - Jupyter notebooks with exploratory data analysis
- `sql/` - SQL queries
- `powerbi/` - dashboard

## Setup

To install the libraries used in this project, run this in a terminal:

```
pip install -r requirements.txt
```

## Key findings

In progress