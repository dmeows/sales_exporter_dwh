{#
Khi mình nhìn vào model hiện tại, mọi người sẽ thấy nó rối hơn. Các hàm lồng vào nhau giống như trên Excel (ví dụ UPPER(TRIM(CAST(brand AS STRING)))). Một số cột được dùng ở nhiều nơi, khi sửa phải cẩn thận để không bị mất đồng bộ (ví dụ CAST(quantity AS NUMERIC) được dùng ở 2 nơi là quantity và gross_amount, khi sửa phải sửa 2 nơi).

Yêu cầu #0105a:
- Tìm cách để quản lý tốt hơn, giảm sự rối rắm cho model này

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
  FROM dim_product__source
)

, dim_product__cast_type AS (
  SELECT 
    CAST(product_id AS INTEGER) AS product_id
    , CAST(product_name AS STRING) AS product_name
    , CAST(brand_name AS STRING) AS brand_name
  FROM dim_product__rename_column
)

SELECT 
  product_id
  , product_name
  , brand_name
FROM dim_product__cast_type
