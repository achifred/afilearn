{{ config(
    materialized = 'view'
) }}

select
    trim(code_module) as module_code,
    trim(code_presentation) as presenatation_code,
    id_student::int as student_id,
    trim(gender) as gender,
    region,
    highest_education,
    idm_band,
    {{ idm_band("age_band", "lower") }} as idm_lower_band,
    {{ idm_band("age_band", "upper") }} as idm_upper_band
    age_band,
    {{ age_band("age_band", "lower") }} as age_lower_band,
    {{ age_band("age_band", "upper") }} as age_upper_band
    num_of_prev_attempts::int as number_of_prev_attempts,
    studied_credits::int as studied_credits,
    disablity,
    final_result
from {{ source('raw', 'student_info') }}