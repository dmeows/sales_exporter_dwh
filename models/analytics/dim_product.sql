{#
Bây giờ bạn thử làm biểu đồ doanh thu theo brand (nhãn hàng) bằng Google Data Studio nha.

Sau khi bạn đã làm biểu đồ doanh thu theo brand, bạn sẽ thấy có brand bị null. Khi đưa lên biểu đồ hoặc lên filter, những giá trị bị null sẽ gây nhầm lẫn và bất tiện. Do đó mình cần phải xử lý null.
Nếu bạn chưa biết null là gì thì coi video này nha 👉https://youtu.be/LllrDN7p1bU

Yêu cầu #0109: Xử lý null ở tất cả các bảng dimension đang có.

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

, dim_product__convert_boolean AS (
  SELECT 
    *
    , CASE
      WHEN is_chiller_stock_boolean IS TRUE THEN 'Chiller Stock'
      WHEN is_chiller_stock_boolean IS FALSE THEN 'Not Chiller Stock'
      ELSE 'Undefined' END
      AS is_chiller_stock
  FROM dim_product__cast_type
)

SELECT 
  dim_product.product_id
  , dim_product.product_name
  , dim_product.brand_name
  , dim_product.is_chiller_stock
  , dim_product.supplier_id
  , dim_supplier.supplier_name
FROM dim_product__convert_boolean AS dim_product
LEFT JOIN {{ ref('dim_supplier') }}
  ON dim_product.supplier_id = dim_supplier.supplier_id
