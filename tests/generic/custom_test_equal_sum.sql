{% test custom_test_equal_sum(
  model, 
  column_name, 
  target_model, 
  target_column,

  source_condition = 'TRUE',
  target_condition = 'TRUE'
) %}


/*
source_condition: filter data on the source table. Default to TRUE.
target_condition: filter data on the target table. Default to TRUE.
*/


WITH source AS (
  SELECT SUM( ({{ column_name }}) ::NUMERIC ) AS source_total
  FROM {{ model }}
  WHERE 
    {{ source_condition }}
)

, target AS (
  SELECT SUM( ({{ target_column }}) ::NUMERIC ) AS target_total
  FROM {{ target_model }}
  WHERE 
    {{ target_condition }}
)

SELECT 
  source.source_total
  , target.target_total
FROM source
CROSS JOIN target
WHERE 
  source.source_total <> target.target_total


{% endtest %}