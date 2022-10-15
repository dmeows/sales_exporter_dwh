
WITH fact_purchase_order_line__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.purchasing__purchase_order_lines`
)

, fact_purchase_order_line__rename_column AS (
  SELECT 
    purchase_order_line_id
    , purchase_order_id
    , stock_item_id AS product_id
    , package_type_id
    , ordered_outers
    , description 
    , received_outers
    , expected_unit_price_per_outer
    , is_order_line_finalized AS is_order_line_finalized_boolean
    , last_receipt_date
    , last_edited_when AS purchase__order__line__last_edited_when
    , last_edited_by AS purchase__order__line__last_edited_by
  FROM fact_purchase_order_line__source
)

, fact_purchase_order_line__cast_type AS (
  SELECT 
    CAST(purchase_order_line_id AS INTEGER) AS purchase_order_line_id
    , CAST(purchase_order_id AS INTEGER) AS purchase_order_id
    , CAST(product_id AS INTEGER) AS product_id
    , CAST(package_type_id AS INTEGER) AS package_type_id
    , CAST(purchase__order__line__last_edited_by AS INTEGER) AS purchase__order__line__last_edited_by
    , CAST(description AS STRING) AS description
    , CAST(ordered_outers AS NUMERIC) AS ordered_outers 
    , CAST(received_outers AS NUMERIC) AS received_outers
    , CAST(expected_unit_price_per_outer AS NUMERIC) AS expected_unit_price_per_outer
    , CAST(is_order_line_finalized_boolean AS BOOLEAN) AS is_order_line_finalized_boolean
    , CAST(last_receipt_date AS TIMESTAMP) AS last_receipt_date
    , CAST(purchase__order__line__last_edited_when AS TIMESTAMP) AS purchase__order__line__last_edited_when
  FROM fact_purchase_order_line__rename_column
)
{# 
, fact_purchase_order_line__calculate_fact AS (
  SELECT 
    *
    , 
  FROM fact_purchase_order_line__cast_type
) #}

SELECT 
  fact_line.purchase_order_line_id
  , fact_line.purchase_order_id
  , COALESCE(fact_header.supplier_id, 0) AS supplier_id
  , COALESCE(fact_header.contact_person_id, 0) AS contact_person_id
  , COALESCE(fact_header.delivery_method_id, 0) AS delivery_method_id
  , fact_line.product_id
  {# , FARM_FINGERPRINT(CONCAT(
    fact_header.
    , fact_line.
  )) AS purchase_order_line_indicator_key #}
    , fact_line.ordered_outers
    , fact_line.description 
    , fact_line.received_outers
    , fact_line.expected_unit_price_per_outer
    , fact_line.is_order_line_finalized_boolean
    , fact_line.last_receipt_date
    , fact_line.purchase__order__line__last_edited_when
    , fact_line.purchase__order__line__last_edited_by
FROM fact_purchase_order_line__cast_type AS fact_line
LEFT JOIN {{ ref('stg_fact_purchase_order') }} AS fact_header
  ON fact_line.purchase_order_id = fact_header.purchase_order_id
