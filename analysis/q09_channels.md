# Q9. Which channels bring good customers?

**Question:** Which channels bring customers who buy again and bring profit, not just sign-ups?

**SQL:** `sql/q09_channels.sql`

**Period:** all data, 2024-01 to 2026-09. A customer is one person (main account, `customer_id = main_customer_id`).

**Bought:** the person has at least one completed order. People with only cancelled or returned orders count as not bought.

**Channel:** `acquisition_source` of the person's main account.

**Same time for everyone:** people who signed up or bought near the end of the data had less time. So in each part I only count what happened in a fixed window, and only people who had the full window:
- Part 1: bought within 30 days of sign-up (sign-ups up to 2026-08-31).
- Part 2: second order within 90 days of the first order (first orders before 2026-07-01), the same as in Q6.
- Part 3: profit in the first 180 days after sign-up (sign-ups up to 2026-04-03).

**Expected** (written before SQL):
- Referral and email bring customers who stay and buy again. Customers from other channels leave more often.

## Answer

**Email and referral bring the best customers. They come back more often and bring the most profit per sign-up (about 33 €). Paid_social and affiliate are the weakest in every part.**

1. Sign-ups who buy: 80.89% (paid_social) to 88.73% (direct). Referral is in the middle (85.85%).
2. Buy again: email 22.73% and referral 21.20% come back within 90 days. Paid_social (11.25%) and affiliate (10.59%) only about half as often.
3. Profit: email (33.52 €) and referral (33.33 €) bring the most per sign-up, affiliate the least (22.09 €).

Expected: Referral and email bring customers who stay and buy again - **yes**, they are the top two in part 2. Customers from other channels leave more often - **partly**. Paid_social and affiliate come back half as often, but direct, paid_search and organic_search are in the middle (17-18%).

## 1. Which channels turn sign-ups into buyers?

First I checked how long people wait between sign-up and the first order, to choose the window:

| Median | Min | Within 7 days | Within 14 days | Within 30 days |
|---|---|---|---|---|
| 0 days | 0 days | 89.88% | 92.02% | 95.10% |

- Most people buy on the same day they sign up. I first thought 2 weeks would be enough, but 30 days catches 95.10% of buyers and costs only the last month of sign-ups.

Sign-ups up to 2026-08-31:

| Channel | Sign-ups | Bought | Share |
|---|---|---|---|
| direct | 1,003 | 890 | 88.73% |
| paid_search | 1,236 | 1,085 | 87.78% |
| email | 381 | 334 | 87.66% |
| referral | 629 | 540 | 85.85% |
| organic_search | 2,017 | 1,727 | 85.62% |
| affiliate | 540 | 453 | 83.89% |
| paid_social | 1,366 | 1,105 | 80.89% |

- Direct and paid_search turn the most sign-ups into buyers. Paid_social turns the fewest, 8 points less than direct.
- If paid_social worked like direct, it would have about 100 more buyers.

## 2. Which channels bring customers who buy again?

Buyers with the first order before 2026-07-01:

| Channel | Buyers | Back within 90 days | Share |
|---|---|---|---|
| email | 308 | 70 | 22.73% |
| referral | 500 | 106 | 21.20% |
| direct | 819 | 149 | 18.19% |
| paid_search | 1,018 | 178 | 17.49% |
| organic_search | 1,601 | 270 | 16.86% |
| paid_social | 1,013 | 114 | 11.25% |
| affiliate | 425 | 45 | 10.59% |

- Email and referral customers come back the most, about 1 in 5.
- Paid_social and affiliate customers come back only about 1 in 10.

## 3. Which channels bring the most profit per sign-up?

Profit in the first 180 days, divided by all sign-ups (people who didn't buy count as 0 €). Sign-ups up to 2026-04-03:

| Channel | Sign-ups | Profit per sign-up (EUR) | Median profit (EUR) |
|---|---|---|---|
| email | 327 | 33.52 | 20.47 |
| referral | 525 | 33.33 | 18.43 |
| direct | 812 | 27.87 | 19.03 |
| organic_search | 1,692 | 27.44 | 17.15 |
| paid_search | 1,016 | 26.65 | 18.30 |
| paid_social | 1,105 | 24.16 | 13.73 |
| affiliate | 439 | 22.09 | 15.76 |

- Email and referral bring about 33 € per sign-up, affiliate only 22.09 €.
- By median, direct (19.03 €) is a bit above referral (18.43 €). So referral's higher mean comes partly from a few bigger customers.
- Paid_social has the lowest median (13.73 €). It also turns the fewest sign-ups into buyers (part 1).

## Recommendations

1. **Send a reminder to paid_social sign-ups who did not buy.** Paid_social turns the fewest sign-ups into buyers (80.89% vs 88.73% for direct). Test it on half of them to see if it helps. (part 1)
2. **Send the Q6 reminder email (60 days after the first order) to paid_social and affiliate buyers first.** Only about 11% of them buy again within 90 days, while email and referral buyers do it about twice as often (21-23%). (part 2)

## Limitations

- In Q7, referral and email already looked better for top customers, so my Expected was not a blind guess.
- The windows (30, 90, 180 days) are my choice. With other windows the numbers would change a bit.
- Part 3 counts only the first 180 days. Customers who come back later bring more profit, and this is not counted.
- The channel is what was saved at sign-up. A customer can come through one channel and buy after an ad from another.
- Marketing cost is not included here. A channel can bring good customers but still be too expensive. Budget between channels should not be moved before checking the cost per channel.
