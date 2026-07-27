{{ config(
    materialized = 'incremental',
    unique_key = 'student_assessment_id',
    on_schema_change='append_new_columns'
) }}

with unique_student_assessments as (
    select
        sa.assessment_id as raw_assessment_id,
        ds.student_id as dim_student_id,
        da.assessment_id as dim_assessment_id,
        sa.date_submitted_offset,
        sa.is_banked,
        sa.score,
        row_number() over (
            partition by sa.assessment_id, ds.student_id
            order by sa.date_submitted_offset desc
        ) as row_num
    from {{ ref('stg_student_assessments') }} sa
    inner join {{ ref('dim_students') }} ds on sa.student_id = ds.student_number
    inner join {{ ref('dim_assessments') }} da on sa.assessment_id = da.assessment_code
)

select
    {{ dbt_utils.generate_surrogate_key(['dim_assessment_id','dim_student_id']) }} as student_assessment_id,
    dim_student_id as student_id,
    dim_assessment_id as assessment_id,
    date_submitted_offset,
    is_banked,
    score,
    current_timestamp::timestamp as created_at,
    current_timestamp::timestamp as updated_at
from unique_student_assessments
where row_num = 1