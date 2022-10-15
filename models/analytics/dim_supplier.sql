{#
  this table could be put in staging (optional)
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

, dim_supplier__add_undefined_record AS (
  SELECT  
    supplier_id
    , supplier_name
  FROM dim_supplier__cast_type

  UNION ALL 
  SELECT 
    0 AS supplier_id
    , 'Undefined' AS supplier_name
)


SELECT 
  supplier_id
  , supplier_name 
FROM dim_supplier__add_undefined_record