{{
    config(
        materialized = 'table'
    )
}}

with unique_modules as (
    select distinct code_module as module_code
    from {{ ref('stg_courses') }}
)
select
    {{ dbt_utils.generate_surrogate_key('module_code') }} as module_id,
    code_module as module_code,
    current_timestamp as created_at,
    current_timestamp as updated_at,
from unique_modules
where code_module is not null