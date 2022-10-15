WITH fact_inventory_transaction__source AS (
  SELECT * 
  FROM `duckdata-320210.wide_world_importers.warehouse__stock_item_transactions`
)

, fact_inventory_transaction__rename AS (
  SELECT
      stock_item_transaction_id AS inventory_transaction_id
      , stock_item_id AS product_id
      , transaction_type_id
      , customer_id
      , invoice_id
      , supplier_id
      , purchase_order_id
      , transaction_occurred_when
      , quantity
      , last_edited_by AS inventory_transaction__last_edited_by
      , last_edited_when AS inventory_transaction__last_edited_when
  FROM fact_inventory_transaction__source
)

, fact_inventory_transaction__cast_type AS (
  SELECT
      CAST(inventory_transaction_id AS INTEGER) AS inventory_transaction_id
      , CAST(product_id AS INTEGER) AS product_id
      , CAST(transaction_type_id AS INTEGER) AS transaction_type_id
      , CAST(customer_id AS INTEGER) AS customer_id
      , CAST(invoice_id AS INTEGER) AS invoice_id
      , CAST(supplier_id AS INTEGER) AS supplier_id
      , CAST(purchase_order_id AS INTEGER) AS purchase_order_id      
      , CAST(transaction_occurred_when AS DATE) AS transaction_occurred_when
      , CAST(quantity AS NUMERIC) AS quantity
      , CAST(inventory_transaction__last_edited_by AS INTEGER) AS inventory_transaction__last_edited_by
      , CAST(inventory_transaction__last_edited_when AS TIMESTAMP) AS inventory_transaction__last_edited_when
  FROM fact_inventory_transaction__rename
)

SELECT 
      inventory_transaction_id
      , product_id
      , transaction_type_id
      , customer_id
      , invoice_id
      , supplier_id
      , purchase_order_id
      , transaction_occurred_when
      , quantity
      , inventory_transaction__last_edited_by
      , inventory_transaction__last_edited_when
FROM fact_inventory_transaction__cast_type 