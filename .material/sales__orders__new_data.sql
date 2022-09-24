WITH latest_last_edited_when AS (
  SELECT MAX(last_edited_when) AS last_edited_when
  FROM `duckdata-320210.wide_world_importers__incremental.sales__orders__yesterday`
)

SELECT 
  *
FROM `duckdata-320210.wide_world_importers__incremental.sales__orders__today`
WHERE 
  last_edited_when > (SELECT last_edited_when FROM latest_last_edited_when)
