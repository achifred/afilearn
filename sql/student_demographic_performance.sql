select

    ds.age_band,

    ds.highest_education,

    ds.region,

    count(*) as total_students,

    round(avg(msp.average_assessment_score), 2) as average_score,

    round(avg(
        case
            when msp.final_result in ('Pass', 'Distinction')
            then 1
            else 0
        end
    ) * 100, 2) as pass_rate

from "afilearn"."mart"."mart_student_performance" msp

join "afilearn"."warehouse"."dim_students" ds
    on msp.student_id = ds.student_id

group by

    ds.age_band,
    ds.highest_education,
    ds.region

order by average_score desc;