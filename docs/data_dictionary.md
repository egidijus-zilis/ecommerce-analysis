# Data dictionary

Online store operating in Lithuania, Latvia and Estonia (warehouse and showroom in Vilnius). Data period: 2024-01-01 to 2026-09-30 (data extracted on 2026-10-01).
All money values are in EUR (VAT is ignored). Timestamps (`*_ts`) are in UTC. Columns named `*_date` are local dates (Europe/Vilnius).
Empty cells in the CSV files are missing values (NULL).

## customers (one row per customer account)
| Column | Description |
|---|---|
| customer_id | Unique account id |
| email_hash | Hashed e-mail address (anonymised) |
| signup_date | Date the account was created |
| country | Country of the customer (LT, LV, EE) |
| city | City as entered by the customer (free text) |
| gender | As entered by the customer (optional) |
| birth_year | Year of birth as entered by the customer (optional) |
| acquisition_source | Marketing source recorded when the account was created |
| marketing_opt_in | 1 if the customer agreed to receive marketing e-mails |

## products (one row per product)
| Column | Description |
|---|---|
| product_id | Unique product id |
| product_name, category, subcategory, brand | Catalogue attributes (Kopa is the store's own brand) |
| list_price | Current list price per unit (last price for discontinued products) |
| unit_cost | Current purchase cost per unit |
| launch_date | Date the product was added to the shop |
| discontinued_date | Date the product was removed from sale (empty if still sold) |

## orders (one row per order)
| Column | Description |
|---|---|
| order_id | Unique order id |
| customer_id | Customer who placed the order |
| session_id | Web session in which the order was placed (may be empty) |
| order_ts | Time the order was placed (UTC) |
| status | completed (delivered or collected), shipped (in transit or ready for collection), processing (not yet shipped), cancelled |
| coupon_code | Coupon used, if any |
| payment_method | card, bank_link, paypal, pay_later, cash_on_delivery |
| delivery_method | courier, parcel_locker, pickup (collection at the Vilnius showroom) |
| shipping_fee | Shipping fee charged to the customer |
| order_total | Value of items after discounts plus shipping_fee |
| promised_date | Delivery date promised at checkout (for pickup: date the order is ready for collection) |
| delivered_date | Date the order was delivered or collected (empty if not delivered) |

## order_items (one row per product line in an order)
| Column | Description |
|---|---|
| order_item_id | Unique line id |
| order_id, product_id | Links to orders and products |
| quantity | Units ordered |
| unit_price | Price per unit at the time of sale, before discount |
| discount_pct | Discount applied to the line, in whole percent (sale or coupon; they do not stack, the larger one applies) |
| is_returned | 1 if the line was returned |
| return_reason | Reason given by the customer |
| return_date | Date the return was registered |

## user_events (one row per web analytics event)
Contains sessions in which at least one product was viewed.

| Column | Description |
|---|---|
| event_id | Unique event id |
| session_id | Web session id |
| visitor_id | Browser (cookie) id |
| customer_id | Customer id, set when the visitor is logged in or at purchase |
| event_type | view_item, add_to_cart, begin_checkout, add_payment_info, purchase |
| event_ts | Event time (UTC) |
| device | desktop, mobile, tablet |
| traffic_source | Marketing source of the session |
| product_id | Product involved (product events only) |

## marketing_spend (one row per day, channel and campaign type)
Each channel's own tool reports its own metrics. Fixed monthly fees (email platform, SEO retainer) are spread evenly over the days of the month. Affiliate spend is commission on approved orders.

| Column | Description |
|---|---|
| spend_date | Date of the spend |
| channel | paid_search, paid_social, email, affiliate, organic_search |
| campaign_type | brand / non_brand (paid_search), prospecting / retargeting (paid_social), newsletter_platform (email), commission (affiliate), seo_retainer (organic_search) |
| impressions | Ad impressions (paid channels), emails delivered (email), link and banner views (affiliate), search result impressions from Search Console (organic_search) |
| clicks | Clicks reported by the channel's own tool (may differ from web sessions) |
| spend_eur | Amount spent |
| platform_conversions | Orders reported by the channel's own tool, using its own attribution rules. Empty for organic_search, which reports no conversions |
