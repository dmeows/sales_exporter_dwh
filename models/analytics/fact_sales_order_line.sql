{#
Yêu cầu #0110a: 
- Lấy thêm dữ liệu cho bảng này: 

| Tên gốc                           | Tên mới             |
|-----------------------------------|---------------------|
| sales__orders.picked_by_person_id | picked_by_person_id |

- Làm biểu đồ doanh thu theo nhân viên đóng gói ("picked_by_person_id")

#}


WITH fact_sales_order_line__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.sales__order_lines`
)

, fact_sales_order_line__rename_column AS (
  SELECT 
    order_line_id AS sales_order_line_id
    , order_id AS sales_order_id
    , stock_item_id AS product_id
    , quantity 
    , unit_price
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
  fact_line.sales_order_line_id
  , fact_line.sales_order_id
  , fact_header.customer_id
  , fact_line.product_id
  , fact_line.quantity 
  , fact_line.unit_price
  , fact_line.gross_amount
  , fact_header.picked_by_person_id
FROM fact_sales_order_line__calculate_fact AS fact_line
LEFT JOIN {{ ref('stg_fact_sales_order') }} AS fact_header
  ON fact_line.sales_order_id = fact_header.sales_order_id
