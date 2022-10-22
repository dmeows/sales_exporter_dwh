
SELECT 
  FORMAT_DATE('%Y', date(fact_sales_order_line.order_date)) as year
  , dim_product.category_name
  , SUM(fact_sales_order_line.gross_amount) as gross_amount
  , SUM(target_revenue.target_revenue) as target_revenue

FROM {{ ref('fact_sales_order_line')}} fact_sales_order_line 
LEFT JOIN {{ ref('dim_product')}} dim_product 
  ON fact_sales_order_line.product_id = dim_product.product_id
LEFT JOIN {{ ref('stg_external__category_target')}} target_revenue
  ON dim_product.category_id = target_revenue.category_id
  AND FORMAT_DATE('%Y', date(fact_sales_order_line.order_date)) = FORMAT_DATE('%Y', date(target_revenue.year))

GROUP BY 1,2