{{
    config(
    materialized = 'incremental',
    unique_key = 'student_performance_id',
    on_schema_change='append_new_columns'
    )
}}


with student_assessment_summary as (
    select
        student_id,
        assessment_id,
        avg(score) as average_assessment_score,
        max(score) as highest_assessment_score,
        min(score) as lowest_assessment_score,
        count(student_id) as assessments_submitted
    
    from {{ ref('fact_student_assessments') }}
    group by student_id, assessment_id
),

student_vle_summary as (
    select
        fv.student_id,
        dv.presentation_id,
        sum(sum_click) as total_vle_clicks
    from {{ ref('fact_student_vles') }} fv
    inner join {{ ref('dim_vles') }} dv on fv.vle_id = dv.vle_id
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
    {{ dbt_utils.generate_surrogate_key(['r.student_id','r.presentation_id']) }} as student_performance_id,
    r.student_id,
    dp.module_id,
    r.presentation_id,
    coalesce(count(sas.assessment_id),0) as total_assessment,
    coalesce(sas.assessments_submitted,0) as assessments_submitted,
    coalesce(avg(sas.average_assessment_score),0) as average_assessment_score,
    coalesce(min(sas.lowest_assessment_score),0) as lowest_assessment_score,
    coalesce(max(sas.highest_assessment_score),0) as highest_assessment_score,
    coalesce(svs.total_vle_clicks, 0) as total_vle_clicks,
    r.final_result,
    {{ is_passed('final_result') }} as is_passed,
    now()::timestamp as created_at,
    now()::timestamp as updated_at
from registration r
inner join {{ ref('dim_module_presentations') }} dp on r.presentation_id = dp.presentation_id
left join student_assessment_summary sas on r.student_id = sas.student_id
left join student_vle_summary svs 
on r.student_id = svs.student_id and r.presentation_id = svs.presentation_id
group by 
    r.student_id,
    dp.module_id,
    r.presentation_id,
    svs.total_vle_clicks,
    sas.assessments_submitted,
    r.final_result


