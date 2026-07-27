select

    da.assessment_type,

    count(*) as submissions,

    round(avg(fsa.score), 2) as average_score,

    sum(
        case
            when fr.final_result = 'Fail'
            then 1
            else 0
        end
    ) as failed_students,

    round(
        avg(
            case
                when fr.final_result = 'Fail'
                then 1
                else 0
            end
        ) * 100,
        2
    ) as failure_rate

from {{ ref('fact_student_assessments') }} fsa

join {{ ref('dim_assessments') }} da
    on fsa.assessment_id = da.assessment_id

join {{ ref('fact_student_registrations') }} fr
    on fsa.student_id = fr.student_id
   and da.presentation_id = fr.presentation_id

group by da.assessment_type

order by failure_rate desc;