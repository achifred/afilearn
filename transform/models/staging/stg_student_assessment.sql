{{ config(
    materialized = 'view'
) }}

select
    
    id_assessment::int as assessment_id,
    id_student::int as student_id,
    date_submitted::int as date_submitted_offset,
    is_banked::int as is_banked,
    score::int as score
from {{ source('raw', 'student_assessment') }}