{#
Yêu cầu #0105b:
- Giảm sự rối rắm cho model này

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
  FROM fact_sales_order_line__source
)

, fact_sales_order_line__cast_type AS (
  SELECT 
    CAST(sales_order_line_id AS INTEGER) AS sales_order_line_id
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
  sales_order_line_id
  , product_id
  , quantity 
  , unit_price
  , gross_amount
FROM fact_sales_order_line__calculate_fact
