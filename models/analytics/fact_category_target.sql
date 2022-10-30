WITH yearly_revenue AS (
  SELECT
    FORMAT_DATE('%Y-%m',order_date) AS month
    , sum(gross_amount) as actual_revenue
  FROM {{ ref('fact_sales_order_line')}} fact_sales_order_line
  GROUP BY 1
)

, target_rev AS (
  SELECT  
    FORMAT_DATE('%Y-%m',year) as month
    , sum(target_revenue) as target_revenue
  FROM {{ ref('stg_external__category_target')}} target_rev
  GROUP BY 1
)

SELECT  distinct 
  dim_month_map_bridge.current_month
  , dim_month_map_bridge.type
  , yearly_revenue.actual_revenue
  , target_rev.target_revenue

FROM {{ ref('dim_month_map_bridge') }} dim_month_map_bridge
LEFT JOIN yearly_revenue ON dim_month_map_bridge.month_original = yearly_revenue.month
LEFT JOIN target_rev ON dim_month_map_bridge.month_original = target_rev.month