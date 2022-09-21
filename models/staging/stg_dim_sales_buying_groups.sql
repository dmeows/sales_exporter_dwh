WITH dim_sales_buying_groups__source AS (
  SELECT * 
  FROM `duckdata-320210.wide_world_importers.sales__customer_categories`
)

, dim_sales_buying_groups__cast_type AS (
  SELECT 
    CAST(buying_group_id AS INTEGER) AS supplier_id
    , CAST(buying_group_name AS STRING) AS supplier_name
  FROM dim_sales_buying_groups__source
)

SELECT 
  supplier_id
  , supplier_name
FROM dim_supplier__cast_type