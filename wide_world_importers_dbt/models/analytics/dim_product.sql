{#
Giả sử bây giờ sếp cần xem doanh thu theo supplier (nhà cung cấp). Bạn hãy thử dùng dữ liệu thô để làm báo cáo này trên Google Data Studio nha.

Nếu mình dùng dữ liệu thô theo Snowflake Schema, mình sẽ cần phải import và tạo quan hệ cho các bảng "sales__order_lines" --> "warehouse__stock_items" --> "purchasing__suppliers".

Nếu mình làm data model, mình chỉ cần đem dữ liệu supplier vào bảng "dim_product", sau đó chỉ cần dùng hai bảng "fact_sales_order_line" và "dim_product" là đủ.
Từ khóa tiếng anh là "flatten many-to-one dimension".

Yêu cầu #0107a:
- Xem thông tin và dữ liệu của bảng "purchasing__suppliers".
- Lấy dữ liệu cho bảng "dim_supplier". Tương tự như "stg_fact_sales_order", mình cũng cần xử lý trước khi JOIN vào "dim_product". Tuy nhiên, bảng "dim_supplier" có khả năng sẽ được sử dụng nên mình sẽ để ở "analytics".

| Tên gốc       | Tên mới       |
|---------------|---------------|
| supplier_id   | supplier_id   |
| supplier_name | supplier_name |

- Flatten dữ liệu "dim_supplier" vào "dim_product".

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
  FROM dim_product__source
)

, dim_product__cast_type AS (
  SELECT 
    CAST(product_id AS INTEGER) AS product_id
    , CAST(product_name AS STRING) AS product_name
    , CAST(brand_name AS STRING) AS brand_name
    , CAST(supplier_id AS INTEGER) AS supplier_id
  FROM dim_product__rename_column
)

SELECT 
  dim_product.product_id
  , dim_product.product_name
  , dim_product.brand_name
  , dim_product.supplier_id
  , dim_supplier.supplier_name
FROM dim_product__cast_type AS dim_product
LEFT JOIN {{ ref('dim_supplier') }}
  ON dim_product.supplier_id = dim_supplier.supplier_id
