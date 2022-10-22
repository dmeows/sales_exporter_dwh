WITH stg_category_target__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.external__category_target`
)

, stg_category_target__cast_type AS (
  SELECT distinct
    CAST(category_id AS INTEGER) AS category_id
    , CAST(target_revenue AS NUMERIC) AS target_revenue 
    , CAST(year AS DATE) AS year
  FROM stg_category_target__source
)

SELECT distinct 
    category_id
    , year
    , target_revenue
FROM stg_category_target__cast_type