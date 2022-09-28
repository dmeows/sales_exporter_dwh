WITH dim_package_type AS (
  SELECT 
    CAST(package_type_id AS INTEGER) AS package_type_id
    , CAST(package_type_name AS STRING) AS package_type_name
  FROM `duckdata-320210.wide_world_importers.warehouse__package_types`
)

, dim_is_undersupply_backordered AS (
  SELECT 
    TRUE AS is_undersupply_backordered_boolean
    , 'Undersupply Backordered' AS is_undersupply_backordered
  
  UNION ALL 
  SELECT 
    FALSE AS is_undersupply_backordered_boolean
    , 'Not Undersupply Backordered' AS is_undersupply_backordered
  
  UNION ALL 
  SELECT 
    NULL AS is_undersupply_backordered_boolean
    , 'Undefined' AS is_undersupply_backordered
)

SELECT 
  FARM_FINGERPRINT(CONCAT(
    dim_package_type.package_type_id
    , dim_is_undersupply_backordered.is_undersupply_backordered_boolean
  )) AS sales_order_line_indicator_key
  
  , dim_package_type.package_type_id
  , dim_package_type.package_type_name
  , dim_is_undersupply_backordered.is_undersupply_backordered_boolean
  , dim_is_undersupply_backordered.is_undersupply_backordered
FROM dim_package_type
CROSS JOIN dim_is_undersupply_backordered
