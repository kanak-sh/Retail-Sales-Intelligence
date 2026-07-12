# Dataset Overview

## olist_customers_dataset

Purpose:
Stores customer information.

Primary Key:
customer_id

Important Columns:
- customer_unique_id
- customer_zip_code_prefix

Possible Cleaning:
- Conver zip codes

## olist_geolocation_dataset

Purpose:
Stores customer location.

Important columns:
- geolocation_zip_code_prefix
- geolocation_lat
- geolocation_lng

Possible Cleaning:
- convert zip codes
- convert city names

## olist_order_items_dataset

Purpose:
Stores order item summary.

Foreign Key:
Order_id
product_id
seller_id

Important Columns:
- price
- freight_value

Possible Cleaning:
- Shipping date-time
- price
- freight value

## olist_order_payments_dataset

Purpose:
Stores payment details

Foreign Key:
order_id

Important Columns:
- payment_type
- payment_installments
- payment_value

Possible Cleaning:
- convert payment_value

## olist_order_reviews_dataset

Purpose:
Stores review lifecycle information.

Primary Key:
review_id

Foreign Key:
Order_id

Important Columns:
- review_score
- review_creation_date
- review_answer_timestamp

Possible Cleaning:
- Missing comment title
- Missing comment message

## olist_orders_dataset

Purpose:
Stores order lifecycle information.

Primary Key:
order_id

Foreign Keys:
customer_id

Important Columns:
- order_status
- order_purchase_timestamp
- order_delivered_customer_date

Possible Cleaning:
- Missing delivery dates
- Convert timestamps

## olist_products_dataset

Purpose:
Stores product description.

Primary Key:
Product_id

Important Columns:
- product_weight_g

Possible Cleaning:
- Missing product name, name length, description length, photo qty
- convert product weight, height, lenth, width

## olist_sellers_dataset

Purpose:
Stores seller's location

Primary Key:
seller_id

Important Columns:
- seller_zip_code_prefix

Possible cleaning:
- convert zip code

## product_category_name_translation

Purpose:
Stores english translation of product names

Foreign key:
Product_category_name

Important Columns:
- product_category_name_english