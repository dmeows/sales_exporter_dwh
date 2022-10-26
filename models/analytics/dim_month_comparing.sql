with revenue AS (
  SELECT 
    FORMAT_DATE('%Y-%m',order_date) as month
    , sum(gross_amount) as revenue
  FROM {{ ref('fact_sales_order_line') }}
  GROUP BY 1
  ORDER BY 1
)

SELECT 
  month_map_bridge.current_month AS month
  , case when type='CY' then revenue.revenue else 0 end as revenue
  , case when type='LY' then revenue.revenue else 0 end as ly_revenue
FROM {{ ref('dim_month_map_bridge' )}} month_map_bridge
LEFT JOIN revenue
  ON month_map_bridge.month_original = revenue.month

WHERE month_map_bridge.current_month between '2013-01' AND '2016-12' 

ORDER BY 1 
