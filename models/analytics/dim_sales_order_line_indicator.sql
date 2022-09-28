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

, dim_sales_order_line_indicator__generate AS (
  SELECT 
    FARM_FINGERPRINT(CONCAT(
      dim_is_undersupply_backordered.is_undersupply_backordered_boolean
      , dim_package_type.package_type_id
    )) AS sales_order_line_indicator_key
    
    , dim_is_undersupply_backordered.is_undersupply_backordered_boolean
    , dim_is_undersupply_backordered.is_undersupply_backordered
    , dim_package_type.package_type_id
    , dim_package_type.package_type_name
  FROM dim_is_undersupply_backordered
  CROSS JOIN dim_package_type
)

, dim_sales_order_line_indicator__cleanse AS (
  SELECT *
  FROM dim_sales_order_line_indicator__generate AS dim_sales_order_line_indicator
  WHERE EXISTS (
    SELECT 1 FROM {{ ref('fact_sales_order_line') }}
    WHERE 
      fact_sales_order_line.sales_order_line_indicator_key = dim_sales_order_line_indicator.sales_order_line_indicator_key
  )
)

SELECT 
  sales_order_line_indicator_key
    
  , is_undersupply_backordered_boolean
  , is_undersupply_backordered
  , package_type_id
  , package_type_name
FROM dim_sales_order_line_indicator__cleanse
