{{
    config(
        materialized = 'incremental',
        unique_key = 'registration_id',
        on_schema_change='append_new_columns'
    )
}}


with unique_registrations as (
    select
        sr.student_id as raw_student_id,
        sr.module_code,
        sr.presentation_code,
        ds.student_id as dim_student_id,
        p.presentation_id,
        si.number_of_prev_attempts,
        sr.date_registered_offset,
        sr.date_unregistered_offset,
        si.final_result,
        row_number() over (
            partition by sr.student_id, sr.module_code, sr.presentation_code
            order by sr.date_registered_offset desc
        ) as row_num
    from {{ref('stg_student_registrations')}} sr
    inner join {{ ref('stg_student_info') }} si 
    on sr.student_id = si.student_id 
    and sr.module_code = si.module_code
    and sr.presentation_code = si.presentation_code
    inner join {{ ref('dim_students') }} ds
    on si.student_id = ds.student_number
    inner join {{ ref('dim_modules') }} m on sr.module_code = m.module_code
    inner join {{ ref('dim_module_presentations') }} p 
    on m.module_id = p.module_id 
    and p.presentation_code = sr.presentation_code
)

select
    {{ dbt_utils.generate_surrogate_key([
        'raw_student_id',
        'module_code',
        'presentation_code'
    ])}} as registration_id,
    dim_student_id as student_id,
    presentation_id,
    number_of_prev_attempts,
    date_registered_offset,
    date_unregistered_offset,
    final_result,
    current_timestamp::timestamp as created_at,
    current_timestamp::timestamp as updated_at
from unique_registrations
where row_num = 1


