{#
Yêu cầu #0108a: Thêm dữ liệu "is_chiller_stock"

#}


WITH dim_product__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.warehouse__stock_items`
)

, dim_product__rename_column AS (
  SELECT 
    stock_item_id AS product_id
    , stock_item_name AS product_name
    , brand AS brand_name
    , supplier_id
    , is_chiller_stock AS is_chiller_stock_boolean
  FROM dim_product__source
)

    {# , case when is_chiller_stock IS TRUE then 'Chiller Stock' 
            when is_chiller_stock IS FALSE then 'Not Chiller Stock'
            else 'Undefined' end as is_chiller_stock #} --them conver_boolean table


, dim_product__cast_type AS (
  SELECT 
    CAST(product_id AS INTEGER) AS product_id
    , CAST(product_name AS STRING) AS product_name
    , CAST(brand_name AS STRING) AS brand_name
    , CAST(supplier_id AS INTEGER) AS supplier_id
    , CAST(is_chiller_stock AS STRING) AS is_chiller_stock
  FROM dim_product__rename_column
)

SELECT 
  dim_product.product_id
  , dim_product.product_name
  , dim_product.brand_name
  , dim_product.supplier_id
  , dim_supplier.supplier_name
  , dim_product.is_chiller_stock
FROM dim_product__cast_type AS dim_product
LEFT JOIN {{ ref('dim_supplier') }}
  ON dim_product.supplier_id = dim_supplier.supplier_id
