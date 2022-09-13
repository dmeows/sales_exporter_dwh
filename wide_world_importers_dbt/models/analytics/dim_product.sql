{#

#}


WITH dim_product__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.warehouse__stock_items`
)

, dim_product__rename_column AS (
  SELECT 
    stock_item_id AS product_id
    , stock_item_name AS product_name
    , brand AS brand_name
  FROM dim_product__source
)

, dim_product__cast_type AS (
  SELECT 
    CAST(product_id AS INTEGER) AS product_id
    , CAST(product_name AS STRING) AS product_name
    , CAST(brand_name AS STRING) AS brand_name
  FROM dim_product__rename_column
)

SELECT 
  product_id
  , product_name
  , brand_name
FROM dim_product__cast_type
