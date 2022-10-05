{# SELECT DISTINCT
    fact_line.package_type_id
    , fact_header.is_undersupply_backordered_boolean
    , FARM_FINGERPRINT(CONCAT(CAST(fact_line.package_type_id AS STRING), CAST(fact_header.is_undersupply_backordered_boolean AS STRING))) AS sales_order_line_indicator_key

FROM {{ ref('fact_sales_order_line') }} AS fact_line
LEFT JOIN {{ ref('stg_fact_sales_order') }} AS fact_header
  ON fact_line.sales_order_id = fact_header.sales_order_id #}


WITH dim_package_types AS (
  SELECT DISTINCT
      CAST(package_type_id AS INTEGER) AS package_type_id
      , CAST(package_type_name AS STRING) AS package_type_name
  FROM `duckdata-320210.wide_world_importers.warehouse__package_types`
)

, dim_supply_backordered AS (
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

SELECT  DISTINCT
    package_type_id
    , package_type_name
    , is_undersupply_backordered_boolean
    , FARM_FINGERPRINT(CONCAT(CAST(package_type_id AS STRING), CAST(is_undersupply_backordered_boolean AS STRING))) AS sales_order_line_indicator_key
FROM dim_package_types
CROSS JOIN dim_supply_backordered