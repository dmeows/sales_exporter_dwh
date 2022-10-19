WITH CTE1 AS (
  SELECT
    format_date('%Y-%m',transaction_occurred_when) as month
    , product_id
    , FARM_FINGERPRINT(CONCAT(CAST(product_id AS STRING), CAST(format_date('%Y-%m',transaction_occurred_when) AS STRING))) AS inventory_transaction_summary_key
    , sum(quantity) AS net_change_quantity
  FROM `first-dwh-prj.wide_world_importers_dwh.fact_inventory_transaction`
  GROUP BY 1,2,3
  )

, CTE2 AS (
  SELECT
    format_date('%Y-%m', order_date) as month
    , product_id
    , FARM_FINGERPRINT(CONCAT(CAST(product_id AS STRING), CAST(format_date('%Y-%m', order_date) AS STRING))) AS inventory_transaction_summary_key
    , sum(quantity) AS sold_quantity
  FROM `first-dwh-prj.wide_world_importers_dwh.fact_sales_order_line`
  GROUP BY 1,2,3
)

, CTE3 AS (
  SELECT distinct 
    dim_product.product_id
    , format_date('%Y-%m', dim_date.year_month) as month
    , FARM_FINGERPRINT(CONCAT(CAST(product_id AS STRING), CAST(format_date('%Y-%m', dim_date.year_month) AS STRING))) AS inventory_transaction_summary_key
  FROM `first-dwh-prj.wide_world_importers_dwh.dim_product` dim_product
  CROSS JOIN `first-dwh-prj.wide_world_importers_dwh.dim_date` dim_date
)

, CTE4 AS (
  SELECT
    CTE3.month
    , CTE3.product_id
    , COALESCE(CTE1.net_change_quantity,0) AS net_change_quantity
    , COALESCE(CTE2.sold_quantity,0) AS sold_quantity
    , CTE3.inventory_transaction_summary_key
  FROM CTE3
  LEFT JOIN CTE1
  ON CTE3.inventory_transaction_summary_key = CTE1.inventory_transaction_summary_key
  LEFT JOIN CTE2
  ON CTE3.inventory_transaction_summary_key = CTE2.inventory_transaction_summary_key
  where CTE1.net_change_quantity is not null
)

SELECT
    month
    , product_id
    , sold_quantity
    , SUM(net_change_quantity) OVER (PARTITION BY product_id ORDER BY month) AS closing_onhand_quantity
    , net_change_quantity
FROM CTE4
ORDER BY 1 DESC