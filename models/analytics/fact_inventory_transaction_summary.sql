SELECT
    product_id
    , sum(quantity) AS quantity_onhand
FROM {{ ref('fact_inventory_transaction') }}
GROUP BY 1