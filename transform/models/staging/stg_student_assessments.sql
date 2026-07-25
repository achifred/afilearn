{{ config(
    materialized = 'view'
) }}

select
    id_assessment::int as assessment_id,
    id_student::int as student_id,
    date_submitted::int as date_submitted_offset,
    {{ boolean_resolver('is_banked') }} as is_banked,
    {{ null_resolver('score','int') }} as score
from {{ source('raw', 'student_assessments') }}