WITH dim_sales_customer_categories__source AS (
  SELECT * 
  FROM `duckdata-320210.wide_world_importers.sales__customer_categories`
)

, dim_sales_customer_categories__cast_type AS (
  SELECT 
    CAST(customer_category_id AS INTEGER) AS customer_category_id
    , CAST(customer_category_name AS STRING) AS customer_category_name
  FROM dim_sales_customer_categories__source
)

SELECT 
  customer_category_id
  , customer_category_name
FROM dim_sales_customer_categories__cast_type