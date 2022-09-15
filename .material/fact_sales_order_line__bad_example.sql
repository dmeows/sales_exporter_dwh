{#
Một số bạn có thể sẽ JOIN thẳng bảng "sales__orders" trong model này luôn. Tuy nhiên đây là một thói quen xấu cần bỏ đi. Khi bạn JOIN trực tiếp "sales_orders", bạn đang dùng data thô chưa qua xử lý (chưa đổi tên, chưa chuyển đổi data type, vân vân). Việc này sẽ làm cho việc quản lý sau này khó khăn hơn nhiều.

#}


WITH fact_sales_order_line__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.sales__order_lines`
)

, fact_sales_order_line__rename_column AS (
  ...
)

, fact_sales_order_line__cast_type AS (
  ...
)

, fact_sales_order_line__calculate_fact AS (
  ...
)


SELECT 
  sales_order_line_id
  , sales_order_id

  {# Cột chưa được làm sạch #}
  , CAST(sales__orders.customer_id AS INTEGER) AS customer_id 
  {# ------ #}

  , product_id
  , quantity 
  , unit_price
  , gross_amount
FROM fact_sales_order_line__calculate_fact AS fact_sales_order_line

{# JOIN trực tiếp, tên bảng chưa được chuẩn hóa #}
LEFT JOIN `duckdata-320210.wide_world_importers.sales__orders` AS sales__orders 
{# ------ #}

  {# Tên cột chưa được chuẩn hóa, cột chưa được làm sạch #}
  ON fact_sales_order_line.sales_order_id = CAST(sales__orders.order_id AS INTEGER) 
  {# ------ #}
