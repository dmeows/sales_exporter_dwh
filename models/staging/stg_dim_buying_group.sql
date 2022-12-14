WITH dim_buying_group__source AS (
  SELECT * 
  FROM `duckdata-320210.wide_world_importers.sales__buying_groups`
)

, dim_buying_group__cast_type AS (
  SELECT 
    CAST(buying_group_id AS INTEGER) AS buying_group_id
    , CAST(buying_group_name AS STRING) AS buying_group_name
  FROM dim_buying_group__source
)


SELECT 
  buying_group_id
  , buying_group_name 
FROM dim_buying_group__cast_type