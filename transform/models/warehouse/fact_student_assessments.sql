{{ config(
    materialized = 'incremental',
    unique_key = 'student_assessment_id'
) }}

select
    {{ dbt_utils.generate_surrogate_key('assessment_id','student_id') }} as student_assessment_id,
    ds.student_id,
    da.assessment_id,
    sa.date_submitted_offset,
    sa.is_banked,
    sa.score,
    current_timestamp as created_at,
    current_timestamp as updated_at
from {{ ref('stg_student_assessments') }} sa
inner join {{ ref('dim_students') }} ds on sa.student_id = ds.student_number
inner join {{ ref('dim_assessments') }} da on sa.assessment_id = da.assessment_code