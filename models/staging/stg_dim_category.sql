WITH stg_dim_category__source AS (
  SELECT 
      category.*
      , category_map.stock_item_id
  FROM `duckdata-320210.wide_world_importers.external__categories` category
  LEFT JOIN `duckdata-320210.wide_world_importers.external__stock_item_categories` category_map
      ON category.category_id = category_map.category_id
)

, stg_dim_category__cast_type AS (
  SELECT distinct
    CAST(stock_item_id AS INTEGER) AS product_id
    , CAST(category_id AS INTEGER) AS category_id
    , CAST(category_name AS STRING) AS category_name
    , CAST(parent_category_id AS INTEGER) AS parent_category_id
    , CAST(category_level AS INTEGER) AS category_level
  FROM stg_dim_category__source
)

SELECT distinct 
    product_id
    , category_id
    , category_name
    , parent_category_id
    , category_level
FROM stg_dim_category__cast_type