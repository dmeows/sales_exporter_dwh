SELECT 
  *
FROM `duckdata-320210.wide_world_importers__incremental.sales__orders__today`
WHERE 
  order_date = CURRENT_DATE - INTERVAL 1 DAY
