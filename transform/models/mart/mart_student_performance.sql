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
        fv.student_id,
        dv.presentation_id,
        sum(sum_click) as total_vle_clicks

    from {{ ref('fact_student_vles') }} fv
    inner join {{ ref('dim_vles') }} dv on fv.vle_id = fv.vle_id
    group by fv.student_id, dv.presentation_id
),

registration as (
    select
        student_id,
        presentation_id,
        final_result
    from {{ ref('fact_student_registrations') }}
)

select 
    {{ dbt_utils.generate_surrogate_key(['student_id','presentation_id']) }} as student_perfomance_id,
    r.student_id,
    dp.module_id,
    r.presentation_id,
    count(sas.assessment_id) as total_assessment,
    avg(sas.average_assessment_score) as average_assessment_score,
    min(sas.lowest_assessment_score) as lowest_assessment_score,
    max(sas.highest_assessment_score) as highest_assessment_score,
    coalcase(svs.total_vle_clicks, 0) as total_vle_clicks,
    r.final_result,
    {{ is_passed('final_result') }} as is_passed
from registration r
inner join {{ ref('dim_presentations') }} dp on r.presentation_id = dp.presentation_id
left join student_assessment_summary sas on r.student_id = sas.student_id
left join student_vle_summary svs 
on r.student_id = svs.student_id and r.presentation_id = svs.presentation_id
group by 
    r.student_id,
    dp.module_id,
    r.presentation_id,
    svs.total_vle_clicks,
    r.final_result


