{{
    config(
        materialized = 'incremental',
        unique_key = 'registration_id'
    )
}}


select
    {{ dbt_utils.generate_surrogate_key([
        'sr.id_student',
        'sr.code_module',
        'sr.code_presentation'
    ])}} as registration_id,
    ds.student_id,
    p.presentation_id,
    si.num_of_prev_attempts::int as number_of_prev_attempts,
    sr.date_registration::int as registration_date_offset,
    sr.date_unregistration::int as unregistered_date_offset,
    si.final_result as final_result,
    current_timestamp as created_at,
    current_timestamp as updated_at
    from {{ref('stg_student_registrations')}} as sr
    inner join {{ ref('stg_student_info') }} as si 
    on sr.id_student = si.student_id 
    and sr.code_module = si.code_module
    and sr.code_presentation = si.code_presentation
    inner join {{ ref('dim_students') }} ds
    on si.student_id = ds.student_number
    inner join {{ ref('dim_modules') }} as m on sr.code_module = m.module_code
    inner join {{ ref('dim_module_presentations') }} as p 
    on m.module_id = p.module_id 
    and p.presentation_code = sr.presentation_code


