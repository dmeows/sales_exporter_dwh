{#
Yêu cầu #0107b:
- Flatten các dữ liệu sau cho bảng "dim_customer":
  - customer_category_id
  - customer_category_name
  - buying_group_id
  - buying_group_name
  - delivery_method_id
  - delivery_method_name

#}


WITH dim_customer__source AS (
  SELECT * 
  FROM `duckdata-320210.wide_world_importers.sales__customers`
)

, dim_customer__cast_type AS (
  SELECT 
    CAST(customer_id AS INTEGER) AS customer_id
    , CAST(customer_name AS STRING) AS customer_name
    , CAST(customer_category_id AS INTEGER) AS customer_category_id
    , CAST(buying_group_id AS INTEGER) AS buying_group_id
    , CAST(delivery_method_id AS INTEGER) AS delivery_method_id
  FROM dim_customer__source
)


SELECT 
  customer_id
  , customer_name 
  , customer_category_id
  , buying_group_id
  , delivery_method_id
FROM dim_customer__cast_type
