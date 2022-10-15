WITH dim_product__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.warehouse__stock_items`
)

, dim_product__rename_column AS (
  SELECT 
    stock_item_id AS product_id
    , stock_item_name AS product_name
    , brand AS brand_name
    , is_chiller_stock AS is_chiller_stock_boolean
    , supplier_id
  FROM dim_product__source
)

, dim_product__cast_type AS (
  SELECT 
    CAST(product_id AS INTEGER) AS product_id
    , CAST(product_name AS STRING) AS product_name
    , CAST(brand_name AS STRING) AS brand_name
    , CAST(is_chiller_stock_boolean AS BOOLEAN) AS is_chiller_stock_boolean
    , CAST(supplier_id AS INTEGER) AS supplier_id
  FROM dim_product__rename_column
)

, dim_product__handle_null AS (
  SELECT 
    product_id
    , product_name
    , COALESCE(brand_name, 'Undefined') AS brand_name
    , is_chiller_stock_boolean
    , supplier_id
  FROM dim_product__cast_type
)

, dim_product__convert_boolean AS (
  SELECT 
    *
    , CASE
      WHEN is_chiller_stock_boolean IS TRUE THEN 'Chiller Stock'
      WHEN is_chiller_stock_boolean IS FALSE THEN 'Not Chiller Stock'
      ELSE 'Undefined' END
      AS is_chiller_stock
  FROM dim_product__handle_null
)

, dim_product__add_undefined_record AS (
  SELECT 
    product_id
    , product_name
    , brand_name
    , is_chiller_stock
    , supplier_id
  FROM dim_product__convert_boolean

  UNION ALL 
  SELECT 
      0 AS product_id
    , 'Undefined' AS product_name
    , 'Undefined' AS brand_name
    , 'Undefined' AS is_chiller_stock
    , 0 AS supplier_id
)

SELECT 
    dim_product.product_id
  , dim_product.product_name
  , dim_product.brand_name
  , dim_product.is_chiller_stock
  , dim_product.supplier_id
  , COALESCE(dim_supplier.supplier_name, 'Undefined') AS supplier_name
FROM dim_product__add_undefined_record AS dim_product
LEFT JOIN {{ ref('dim_supplier') }}
  ON dim_product.supplier_id = dim_supplier.supplier_id