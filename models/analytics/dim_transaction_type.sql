WITH dim_transaction_type__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.application__transaction_types`
)

, dim_transaction_type__rename AS (
  SELECT
    transaction_type_id
    , transaction_type_name
    , last_edited_by AS transaction_type_last_edited_by
  FROM dim_transaction_type__source

)

, dim_transaction_type__cast_type AS (
  SELECT
      CAST(transaction_type_id AS INTEGER) AS transaction_type_id
      , CAST(transaction_type_name AS STRING) AS transaction_type_name
      , CAST(transaction_type_last_edited_by AS INTEGER) AS transaction_type_last_edited_by
  FROM dim_transaction_type__rename
)

SELECT
    transaction_type_id
    , transaction_type_name
    , transaction_type_last_edited_by
FROM dim_transaction_type__cast_type