WITH dim_sales_buying_groups__source AS (
  SELECT * 
  FROM `duckdata-320210.wide_world_importers.sales__buying_groups`
)

, dim_sales_buying_groups__cast_type AS (
  SELECT 
    CAST(buying_group_id AS INTEGER) AS buying_group_id
    , CAST(buying_group_name AS STRING) AS buying_group_name
  FROM dim_sales_buying_groups__source
)

SELECT 
  buying_group_id
  , buying_group_name
FROM dim_sales_buying_groups__cast_type