
  SELECT
    FORMAT_DATE('%Y-%m', year_month) AS month_original
    , FORMAT_DATE('%Y-%m', year_month) AS current_month
    , 'CY' AS type
  FROM {{ref('dim_date')}}
  GROUP BY 1,2

UNION DISTINCT 
SELECT
    FORMAT_DATE('%Y-%m', DATE_SUB(DATE(year_month), INTERVAL 1 YEAR))  AS month_original
    , FORMAT_DATE('%Y-%m', year_month) AS current_month
    , 'LY' AS type
  FROM {{ref('dim_date')}}
GROUP BY 1,2

ORDER BY 1





