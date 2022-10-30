WITH yearly_revenue AS (
  SELECT
    FORMAT_DATE('%Y-%m',order_date) AS month
    , sum(gross_amount) as actual_revenue
  FROM {{ ref('fact_sales_order_line')}} fact_sales_order_line
  GROUP BY 1
)

SELECT  distinct 
  dim_month_map_bridge.current_month
  , dim_month_map_bridge.type
  , yearly_revenue.actual_revenue

FROM {{ ref('dim_month_map_bridge') }} dim_month_map_bridge
LEFT JOIN yearly_revenue ON dim_month_map_bridge.month_original = yearly_revenue.month
