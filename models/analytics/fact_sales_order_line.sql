{#
Yêu cầu #0105b:
- Giảm sự rối rắm cho model này
#CTE source
#CTE rename
#CTE cast type
#naming: dim_tablename_practice
#}


WITH fact_sales_order_line__source AS(
  SELECT 
    *
  FROM `duckdata-320210.wide_world_importers.sales__order_lines`
),

fact_sales_order_line__rename AS(
  SELECT 
    order_line_id AS sales_order_line_id
    , quantity
    , unit_price
    , stock_item_id AS product_id
  FROM fact_sales_order_line__source
),

fact_sales_order_line__calculate AS(
  SELECT *,
    quantity*unit_price as gross_amount
  FROM fact_sales_order_line__rename
),

fact_sales_order_line__cast AS(
  SELECT 
    CAST(sales_order_line_id AS INTEGER) AS sales_order_line_id
    , CAST(product_id AS INTEGER) AS product_id
    , CAST(quantity AS NUMERIC) AS quantity 
    , CAST(unit_price AS NUMERIC) AS unit_price
    , CAST(gross_amount AS NUMERIC) AS gross_amount
  FROM fact_sales_order_line__calculate
)

SELECT *
FROM fact_sales_order_line__cast

