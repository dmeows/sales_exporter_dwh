SELECT 
  person_id AS picked_by_person_id
  , person_full_name AS picked_by_person_full_name
FROM {{ ref('dim_person') }}