# Q12. Where do shoppers stop before buying?

**Question:** Where do shoppers stop before buying? Is it different by device or traffic source?

**SQL:** `sql/q12_funnel.sql`

**Period:** all data, 2024-01 to 2026-09.

**Data:** `clean.user_events`, one row per web event. The bot (DQ-19) and double purchase events (DQ-15) are already removed. Only sessions where at least one product was viewed are in the data.

**Funnel steps:** view_item → add_to_cart → begin_checkout → add_payment_info → purchase. I count sessions that reached each step, and compare each step with the step before.

**Traffic source:** the source of the session (visit), not the customer's first channel from Q9. The same person can come from email one day and from Google the next.

**Expected** (written before SQL):
- Most shoppers stop after view_item and do nothing else.
- The second biggest drop is from add_to_cart to begin_checkout.
- Email and referral sessions buy the most.
- Mobile converts the best.

## Answer

**Most shoppers stop right after viewing a product, and the second big drop is between the cart and checkout. Mobile and paid_social convert the worst, and on mobile many people leave at the payment step.**

1. Where shoppers stop: only 11.57% of sessions add something to the cart. Of those, only 55.44% start checkout. In the end 4.62% of sessions buy.
2. By device: mobile converts the worst (3.99%), desktop the best (6.14%). The biggest gap is at the payment step: 80.77% on mobile vs 92.35% on desktop.
3. By traffic source: email converts the best (6.85%), paid_social the worst (2.61%). Paid_social is weak on desktop too, but on mobile it is much worse (2.05%).

Expected:
- Most shoppers stop after view_item - **yes**, 88.43% don't add anything to the cart.
- The second biggest drop is from add_to_cart to begin_checkout - **yes**, 44.56% leave there.
- Email and referral buy the most - **partly**. Email is first, but referral is in the middle (4.66%).
- Mobile converts the best - **no**, it converts the worst.

## 1. Where do shoppers stop before buying?

| Step | Sessions | From step before |
|---|---|---|
| view_item | 209,306 | - |
| add_to_cart | 24,210 | 11.57% |
| begin_checkout | 13,423 | 55.44% |
| add_payment_info | 11,405 | 84.97% |
| purchase | 9,673 | 84.81% |

- From view to purchase: 4.62%.
- The biggest drop is right after viewing. Most visitors look at products and leave.
- The second drop is between cart and checkout. Almost half of the people with a cart don't start checkout.
- After checkout starts, about 15% leave at each of the last two steps.

## 2. Is it different by device?

| Device | Sessions | View → cart | Cart → checkout | Checkout → payment | Payment → purchase | View → purchase |
|---|---|---|---|---|---|---|
| desktop | 56,288 | 13.06% | 58.13% | 92.35% | 87.49% | 6.14% |
| tablet | 10,521 | 11.61% | 55.07% | 90.94% | 86.76% | 5.05% |
| mobile | 142,497 | 10.97% | 54.21% | 80.77% | 83.10% | 3.99% |

- Mobile is the worst in every step.
- The biggest gap is checkout → payment: 80.77% on mobile vs 92.35% on desktop. In the other steps the gap is 2.1-4.4 points.
- Mobile has 68% of all sessions (142,497 of 209,306), so this step affects the most people.

## 3. Is it different by traffic source?

| Source | Sessions | View → cart | Cart → checkout | Checkout → payment | Payment → purchase | View → purchase |
|---|---|---|---|---|---|---|
| email | 17,915 | 13.92% | 62.27% | 89.44% | 88.34% | 6.85% |
| paid_search | 28,355 | 12.43% | 59.32% | 88.38% | 88.58% | 5.77% |
| direct | 34,018 | 12.87% | 57.63% | 87.20% | 86.95% | 5.62% |
| referral | 15,017 | 11.55% | 56.14% | 85.11% | 84.44% | 4.66% |
| organic_search | 53,208 | 11.32% | 54.46% | 83.93% | 84.45% | 4.37% |
| unknown | 4,104 | 11.31% | 53.66% | 83.13% | 85.99% | 4.34% |
| affiliate | 14,022 | 11.06% | 53.51% | 85.06% | 81.87% | 4.12% |
| paid_social | 42,667 | 9.47% | 47.60% | 76.60% | 75.70% | 2.61% |

- Email converts the best (6.85%). Paid_social converts the worst (2.61%) and is the lowest in every step.
- Facebook and Instagram ads are mostly seen on the phone, so I checked if paid_social is weak only because of mobile:

| Source | Mobile share of sessions | Desktop view → purchase | Mobile view → purchase | Mobile checkout → payment |
|---|---|---|---|---|
| email | 63.15% | 8.30% | 6.13% | 86.77% |
| paid_search | 65.56% | 7.44% | 5.05% | 84.65% |
| direct | 64.50% | 6.93% | 4.94% | 82.98% |
| referral | 66.13% | 5.59% | 4.33% | 81.63% |
| organic_search | 66.02% | 5.26% | 4.01% | 79.97% |
| affiliate | 67.39% | 4.94% | 3.75% | 81.58% |
| unknown | 68.10% | 6.06% | 3.54% | 78.00% |
| paid_social | 78.15% | 4.78% | 2.05% | 71.34% |

- It is both. On desktop paid_social is also the lowest (4.78%), so the channel is a bit weaker by itself.
- But on mobile it is much worse: 2.05%, while other sources are 3.54-6.13%. At the payment step only 71.34% continue.
- 78.15% of paid_social sessions are on mobile, more than any other source (63-68%). So the weak mobile payment step pulls paid_social down the most.

## Recommendations

1. **Make mobile payment easier and test it (for example Apple Pay or Google Pay).** On mobile only 80.77% go from checkout to payment, on desktop 92.35%. (part 2)
2. **Fix mobile payment before changing the paid_social budget.** 78.15% of paid_social sessions are on mobile, and its mobile payment step is the weakest (71.34%). (part 3)

## Limitations

- Only sessions with at least one product view are in the data. Visits that left from the home page are not counted.
- Each session is counted on its own. If someone looks on the phone and buys later on a computer, the phone session counts as a drop.
- The data does not say why people leave, only where.
- 4,104 sessions have no traffic source (DQ-14). They are shown as "unknown".
- I did not compare purchase events with the orders table.
