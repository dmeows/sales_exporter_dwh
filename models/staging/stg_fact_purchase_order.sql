WITH purchase_order__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.purchasing__purchase_orders`
)

, fact_purchase_order__rename_column AS (
  SELECT 
    purchase_order_id
    , supplier_id
    , delivery_method_id
    , contact_person_id
    , is_order_finalized
    , comments
    , internal_comments
    , order_date
    , expected_delivery_date
    , last_edited_by AS purchase__order__last_edited_by_person_id
    , last_edited_when AS purchase__order__last_edited_when
  FROM purchase_order__source
)

, fact_purchase_order__cast_type AS (
  SELECT 
    CAST(purchase_order_id AS INTEGER) AS purchase_order_id
    , CAST(supplier_id AS INTEGER) AS supplier_id
    , CAST(delivery_method_id AS INTEGER) AS delivery_method_id
    , CAST(contact_person_id AS INTEGER) AS contact_person_id
    , CAST(is_order_finalized AS BOOLEAN) AS is_order_finalized
    , CAST(comments AS STRING) AS comments
    , CAST(internal_comments AS STRING) AS internal_comments
    , CAST(order_date AS DATE) AS order_date
    , CAST(expected_delivery_date AS DATE) AS expected_delivery_date
    , CAST(purchase__order__last_edited_by_person_id AS INTEGER) AS purchase__order__last_edited_by_person_id
    , CAST(purchase__order__last_edited_when AS TIMESTAMP) AS purchase__order__last_edited_when
  FROM fact_purchase_order__rename_column
)


SELECT 
    purchase_order_id
    , supplier_id
    , delivery_method_id
    , contact_person_id
    , is_order_finalized
    , comments
    , internal_comments
    , order_date
    , expected_delivery_date
    , purchase__order__last_edited_by_person_id
    , purchase__order__last_edited_when
FROM fact_purchase_order__cast_type