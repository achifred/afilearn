{{
    config(
        materialized = 'table'
    )
}}

with unique_activity_types as (
    select distinct activity_type as vle_activity_type
    from {{ ref('stg_vles') }} 
)
select
    {{ dbt_utils.generate_surrogate_key(['vle_activity_type']) }} as vle_activity_type_id,
    vle_activity_type,
    current_timestamp::timestamp as created_at,
    current_timestamp::timestamp as updated_at
from unique_activity_types