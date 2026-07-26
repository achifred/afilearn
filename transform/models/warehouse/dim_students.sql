{{
    config(
        materialized = 'incremental',
        unique_key = 'student_id',
        on_schema_change='append_new_columns'
    )
}}

with unique_students as (
    select
        student_id,
        region,
        highest_education,
        idm_band,
        idm_lower_band,
        idm_upper_band,
        age_band,
        age_lower_band,
        age_upper_band,
        studied_credits,
        is_disabled,
        row_number() over (
                partition by student_id
            ) as row_num
    from {{ ref('stg_student_info') }}
) 

select
    {{ dbt_utils.generate_surrogate_key(['student_id']) }} as student_id,
    student_id as student_number,
    region,
    highest_education,
    idm_band,
    idm_lower_band,
    idm_upper_band,
    age_band,
    age_lower_band,
    age_upper_band,
    studied_credits,
    is_disabled,
    current_timestamp::timestamp as created_at,
    current_timestamp::timestamp as updated_at
from unique_students
where student_id is not null and row_num = 1