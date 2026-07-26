{{
    config(
        materialized = 'incremental',
        unique_key = 'registration_id',
        on_schema_change='append_new_columns'
    )
}}


select
    {{ dbt_utils.generate_surrogate_key([
        'sr.student_id',
        'sr.module_code',
        'sr.presentation_code'
    ])}} as registration_id,
    ds.student_id,
    p.presentation_id,
    si.number_of_prev_attempts,
    sr.date_registered_offset,
    sr.date_unregistered_offset,
    si.final_result as final_result,
    current_timestamp::timestamp as created_at,
    current_timestamp::timestamp as updated_at
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


