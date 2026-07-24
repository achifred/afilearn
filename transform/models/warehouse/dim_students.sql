{{
    config(
        materialized = 'incremental',
        unique_key = 'student_id',
    )
}}


select
    {{ dbt_utils.generate_surrogate_key('student_number') }} as student_id,
    id_student::int as student_number,
    region,
    highest_education,
    idm_band,
    idm_lower_band,
    idm_upper_band,
    age_band,
    age_lower_band,
    age_upper_band,
    studies_credits::int,
    disability,
    current_timestamp as created_at,
    current_timestamp as updated_at,
from {{ ref('stg_student_info') }}
where id_student is not null
{% if is_incremental() %}
    and id_student not in (select student_id from {{ this }})
{% endif %}