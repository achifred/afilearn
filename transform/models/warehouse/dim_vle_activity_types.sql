{{
    config(
        materialized = 'table'
    )
}}

with unique_modules as (
    select distinct activity_type as vle_activity_type
    from {{ ref('stg_vles') }} 
)
select
    {{ dbt_utils.generate_surrogate_key('vle_activity_type') }} as vle_activity_type_id,
    activity_type as vle_activity_type,
    current_timestamp as created_at,
    current_timestamp as updated_at,
from unique_modules
where code_module is not null