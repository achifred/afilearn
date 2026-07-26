{{
    config(
        materialized = 'table'
    )
}}

with unique_modules as (
    select distinct module_code
    from {{ ref('stg_courses') }}
)
select
    {{ dbt_utils.generate_surrogate_key(['module_code']) }} as module_id,
    module_code,
    current_timestamp::timestamp as created_at,
    current_timestamp::timestamp as updated_at
from unique_modules
where module_code is not null