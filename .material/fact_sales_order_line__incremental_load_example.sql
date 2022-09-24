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
    , last_edited_when
  FROM fact_sales_order_line__source
)

, fact_sales_order_line__cast_type AS (
  SELECT 
    CAST(sales_order_line_id AS INTEGER) AS sales_order_line_id
    , CAST(sales_order_id AS INTEGER) AS sales_order_id
    , CAST(product_id AS INTEGER) AS product_id
    , CAST(quantity AS NUMERIC) AS quantity 
    , CAST(unit_price AS NUMERIC) AS unit_price
    , CAST(last_edited_when AS TIMESTAMP) AS last_edited_when
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
  , COALESCE(fact_header.customer_id, 0) AS customer_id
  , COALESCE(fact_header.picked_by_person_id, 0) AS picked_by_person_id
  , fact_line.product_id
  , fact_header.order_date
  , fact_line.quantity 
  , fact_line.unit_price
  , fact_line.gross_amount
  , fact_line.last_edited_when
  , fact_header.sales__orders__last_edited_when
FROM fact_sales_order_line__calculate_fact AS fact_line
LEFT JOIN `vit-hoc-data.wide_world_importers_dwh_staging.stg_fact_sales_order` AS fact_header
  ON fact_line.sales_order_id = fact_header.sales_order_id
ORDER BY 
  last_edited_when DESC
  sales__orders__last_edited_when DESC
;



SELECT MAX(last_edited_when) 
FROM `vit-hoc-data.wide_world_importers_dwh.fact_sales_order_line`
;



SELECT MAX(sales__orders__last_edited_when) 
FROM `vit-hoc-data.wide_world_importers_dwh.fact_sales_order_line`
;