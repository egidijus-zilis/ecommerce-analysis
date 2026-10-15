CREATE TABLE raw.customers (
    customer_id        integer,
    email_hash         text,
    signup_date        date,
    country            text,
    city               text,
    gender             text,
    birth_year         integer,
    acquisition_source text,
    marketing_opt_in   integer
);
CREATE TABLE raw.products (
    product_id         integer,
    product_name       text,
    category           text,
    subcategory        text,
    brand              text,
    list_price         numeric(10,2),
    unit_cost          numeric(10,2),
    launch_date        date,
    discontinued_date  date
);
CREATE TABLE raw.orders (
    order_id           integer,
    customer_id        integer,
    session_id         integer,
    order_ts           timestamp,
    status             text,
    coupon_code        text,
    payment_method     text,
    delivery_method    text,
    shipping_fee       numeric(10,2),
    order_total        numeric(10,2),
    promised_date      date,
    delivered_date     date 
);
CREATE TABLE raw.order_items (
    order_item_id      integer,
    order_id           integer,
    product_id         integer,
    quantity           integer,
    unit_price         numeric(10,2),
    discount_pct       integer,
    is_returned        integer,
    return_reason      text,
    return_date        date
);
CREATE TABLE raw.user_events (
    event_id           integer,
    session_id         integer,
    visitor_id         bigint,
    customer_id        integer,
    event_type         text,
    event_ts           timestamp,
    device             text,
    traffic_source     text,
    product_id         integer
);
CREATE TABLE raw.marketing_spend (
    spend_date           date,
    channel              text,
    campaign_type        text,
    impressions          integer,
    clicks               integer,
    spend_eur            numeric(10,2),
    platform_conversions integer
);