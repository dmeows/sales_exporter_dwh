SELECT 
  person_id AS salesperson_person_id
  , person_full_name AS salesperson_person_full_name
FROM {{ ref('dim_person') }}
