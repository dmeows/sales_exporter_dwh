{#
Yêu cầu #0108b: Thêm dữ liệu "is_on_credit_hold"

#}


WITH dim_customer__source AS (
  SELECT * 
  FROM `duckdata-320210.wide_world_importers.sales__customers`
)

, dim_customer__rename_column AS (
  SELECT 
    customer_id
    , customer_name
    , is_on_credit_hold AS is_on_credit_hold_boolean
    , customer_category_id
    , buying_group_id
    , delivery_method_id
  FROM dim_customer__source
)

, dim_customer__cast_type AS (
  SELECT 
    CAST(customer_id AS INTEGER) AS customer_id
    , CAST(customer_name AS STRING) AS customer_name
    , CAST(is_on_credit_hold_boolean AS BOOLEAN) AS is_on_credit_hold_boolean
    , CAST(customer_category_id AS INTEGER) AS customer_category_id
    , CAST(buying_group_id AS INTEGER) AS buying_group_id
    , CAST(delivery_method_id AS INTEGER) AS delivery_method_id
  FROM dim_customer__rename_column
)

, dim_customer__convert_boolean AS (
  SELECT
    *
    , CASE 
      WHEN is_on_credit_hold_boolean IS TRUE THEN 'On Credit Hold'
      WHEN is_on_credit_hold_boolean IS FALSE THEN 'Not On Credit Hold'
      ELSE 'Undefined' END 
      AS is_on_credit_hold
  FROM dim_customer__cast_type
)


SELECT 
  dim_customer.customer_id
  , dim_customer.customer_name 
  , dim_customer.is_on_credit_hold
  , dim_customer.customer_category_id
  , dim_customer_category.customer_category_name
  , dim_customer.buying_group_id
  , dim_buying_group.buying_group_name
  , dim_customer.delivery_method_id
  , dim_delivery_method.delivery_method_name
FROM dim_customer__convert_boolean AS dim_customer
LEFT JOIN {{ ref('stg_dim_customer_category') }} AS dim_customer_category
  ON dim_customer.customer_category_id = dim_customer_category.customer_category_id
LEFT JOIN {{ ref('stg_dim_buying_group') }} AS dim_buying_group
  ON dim_customer.buying_group_id = dim_buying_group.buying_group_id
LEFT JOIN {{ ref('stg_dim_delivery_method') }} AS dim_delivery_method
  ON dim_customer.delivery_method_id = dim_delivery_method.delivery_method_id
