{#

#}


WITH dim_supplier__source AS (
  SELECT * 
  FROM `duckdata-320210.wide_world_importers.purchasing__suppliers`
)

, dim_supplier__cast_type AS (
  SELECT 
    CAST(supplier_id AS INTEGER) AS supplier_id
    , CAST(supplier_name AS STRING) AS supplier_name
  FROM dim_supplier__source
)


SELECT 
  supplier_id
  , supplier_name 
FROM dim_supplier__cast_type
