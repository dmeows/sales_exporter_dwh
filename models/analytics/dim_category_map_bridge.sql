
select DISTINCT 
    category_id AS parent_category_id
    , category_id AS child_category_id
    , 0 AS depth_from_parent
from {{ref('stg_dim_category')}}

UNION DISTINCT

select DISTINCT 
    parent_category_id 
    , category_id AS child_category_id
    , 1 AS depth_from_parent
from {{ref('stg_dim_category')}}
where parent_category_id != 0

UNION DISTINCT

select DISTINCT
    parent_category.parent_category_id 
    , category.category_id AS child_category_id
    , 2 AS depth_from_parent
from {{ref('stg_dim_category')}} category
join {{ref('stg_dim_category')}} parent_category
on category.parent_category_id = parent_category.category_id
where parent_category.parent_category_id != 0

UNION DISTINCT

select DISTINCT
    grant_parent_category.parent_category_id as parent_category_id
    , category.category_id AS child_category_id
    , 3 AS depth_from_parent
from {{ref('stg_dim_category')}} category
join {{ref('stg_dim_category')}} parent_category
on category.parent_category_id = parent_category.category_id
join {{ref('stg_dim_category')}} grant_parent_category
on parent_category.parent_category_id = grant_parent_category.category_id

where grant_parent_category.parent_category_id != 0

ORDER BY 3,1