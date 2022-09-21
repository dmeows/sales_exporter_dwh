{#
Theo mô hình Snowflake Schema:
- Dữ liệu thuộc về một dòng trong đơn hàng sẽ nằm bên bảng "sales__order_lines", hay còn gọi chung là bảng Line.
- Dữ liệu thuộc về ĐƠN HÀNG sẽ nằm bên bảng "sales__orders", hay còn gọi chung là bảng Header.
Nếu chỗ này chưa hiểu, bạn cần xem lại chuỗi Data Modeling: https://www.youtube.com/playlist?list=PL01fPqVNMdrlMwymamk6zuISnC6USwAtI

Chúng ta cũng sẽ cần lấy data của bảng Header và đem nó vào "fact_sales_order_line" để tiện cho sau này (tiện sao thì bài sau sẽ rõ 😁).

Yêu cầu #0106a:
- Xem thông tin và dữ liệu của bảng "sales__orders"
- Lấy thêm dữ liệu cho bảng này: 

| Tên gốc                   | Tên mới     |
|---------------------------|-------------|
| sales__orders.customer_id | customer_id |

#}


WITH fact_sales_order_line__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.sales__order_lines`
)

, fact_sales_order_line__rename_column AS (
  SELECT 
    order_line_id AS sales_order_line_id
    , stock_item_id AS product_id
    , quantity 
    , unit_price
    , order_id AS sales_order_id
  FROM fact_sales_order_line__source
)

, fact_sales_order_line__cast_type AS (
  SELECT 
    CAST(sales_order_line_id AS INTEGER) AS sales_order_line_id
    , CAST(sales_order_id AS INTEGER) AS sales_order_id
    , CAST(product_id AS INTEGER) AS product_id
    , CAST(quantity AS NUMERIC) AS quantity 
    , CAST(unit_price AS NUMERIC) AS unit_price
  FROM fact_sales_order_line__rename_column
)

, fact_sales_order_line__calculate_fact AS (
  SELECT 
    *
    , quantity * unit_price AS gross_amount
  FROM fact_sales_order_line__cast_type
)

SELECT 
  ol.sales_order_line_id
  , ol.sales_order_id
  , ol.product_id
  , ol.quantity 
  , ol.unit_price
  , ol.gross_amount
  , so.customer_id
FROM fact_sales_order_line__calculate_fact ol
LEFT JOIN `first-dwh-prj.wide_world_importers_dwh_staging.fact_sales_order` so
    ON ol.sales_order_id = so.sales_order_id


