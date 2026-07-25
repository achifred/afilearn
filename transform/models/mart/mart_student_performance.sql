{{
    confing(
    materialized = 'incremental',
    )
}}


with student_assessment_summary as (
    select
        student_id,
        assessment_id,
        avg(score) as average_assessment_score,
        max(score) as highest_assessment_score,
        min(score) as lowest_assesssment_score,
        count(student_assessment_id) as assessments_submitted
    
    from {{ ref('fact_student_assesssments') }}
    group by student_id, assessment_id
),
student_vle_summary as (
    select
        student_id,
    from {{ ref('fact_student_vles') }} fv
    inner join {{ ref('') }}
)