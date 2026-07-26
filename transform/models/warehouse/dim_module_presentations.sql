{{
    config(
        materialized = 'incremental',
        unique_key = 'presentation_id',
        on_schema_change='append_new_columns'
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['module_code, presentation_code']) }} as presentation_id,
    m.module_id,
    c.presentation_code,
    c.module_presentation_length,
    current_timestamp as created_at,
    current_timestamp as updated_at
from {{ ref('stg_courses') }} c
inner join {{ ref('dim_modules') }} m on c.code_module = m.module_code