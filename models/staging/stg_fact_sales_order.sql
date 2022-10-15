WITH fact_sales_order__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.sales__orders`
)

, fact_sales_order__rename_column AS (
  SELECT 
    order_id AS sales_order_id
    , customer_id
    , picked_by_person_id
    , salesperson_person_id
    , is_undersupply_backordered AS is_undersupply_backordered_boolean
    , order_date
    , last_edited_when AS sales__orders__last_edited_when
  FROM fact_sales_order__source
)

, fact_sales_order__cast_type AS (
  SELECT 
    CAST(sales_order_id AS INTEGER) AS sales_order_id
    , CAST(customer_id AS INTEGER) AS customer_id
    , CAST(picked_by_person_id AS INTEGER) AS picked_by_person_id
    , CAST(salesperson_person_id AS INTEGER) AS salesperson_person_id
    , CAST(is_undersupply_backordered_boolean AS BOOLEAN) AS is_undersupply_backordered_boolean
    , CAST(order_date AS DATE) AS order_date
    , CAST(sales__orders__last_edited_when AS TIMESTAMP) AS sales__orders__last_edited_when
  FROM fact_sales_order__rename_column
)


SELECT 
  sales_order_id
  , customer_id
  , picked_by_person_id
  , salesperson_person_id
  , is_undersupply_backordered_boolean
  , order_date
  , sales__orders__last_edited_when
FROM fact_sales_order__cast_type