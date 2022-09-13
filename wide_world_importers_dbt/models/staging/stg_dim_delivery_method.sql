WITH dim_delivery_method__source AS (
  SELECT * 
  FROM `duckdata-320210.wide_world_importers.application__delivery_methods`
)

, dim_delivery_method__cast_type AS (
  SELECT 
    CAST(delivery_method_id AS INTEGER) AS delivery_method_id
    , CAST(delivery_method_name AS STRING) AS delivery_method_name
  FROM dim_delivery_method__source
)


SELECT 
  delivery_method_id
  , delivery_method_name 
FROM dim_delivery_method__cast_type
