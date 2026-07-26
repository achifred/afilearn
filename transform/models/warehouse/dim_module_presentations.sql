{{
    config(
        materialized = 'incremental',
        unique_key = 'presentation_id',
        on_schema_change='append_new_columns'
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['c.module_code', 'c.presentation_code']) }} as presentation_id,
    m.module_id,
    c.presentation_code,
    c.module_presentation_length,
    current_timestamp::timestamp as created_at,
    current_timestamp::timestamp as updated_at
from {{ ref('stg_courses') }} c
inner join {{ ref('dim_modules') }} m on c.module_code = m.module_code