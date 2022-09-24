WITH dim_sales_customers__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.sales__customers`
)

, dim_sales_customers__rename AS (
  SELECT 
      customer_id
      , is_on_credit_hold AS is_on_credit_hold_boolean
  FROM dim_sales_customers__source
)

, dim_sales_customers__conver_boolean AS (
  SELECT 
      *,
      case when is_on_credit_hold_boolean IS TRUE then 'On Credit Hold'
            when is_on_credit_hold_boolean IS FALSE then 'Not On Credit Hold'
            ELSE 'Undefined' END AS is_on_credit_hold
  FROM dim_sales_customers__rename
)

, dim_sales_customers__cast_type AS(
  SELECT  
      CAST(customer_id AS INTEGER) AS customer_id
      , CAST(is_on_credit_hold_boolean AS BOOLEAN) AS is_on_credit_hold_boolean
      , CAST(is_on_credit_hold AS STRING) AS is_on_credit_hold
  FROM  dim_sales_customers__conver_boolean
)

SELECT 
    customer_id
    , is_on_credit_hold
FROM dim_sales_customers__cast_type