select

    ds.student_number,

    dm.module_code,

    dp.presentation_code,

    ds.region,

    ds.highest_education,

    msp.average_assessment_score as average_score,

    msp.total_vle_clicks,

    msp.final_result,

    case

        when msp.average_assessment_score < 40
             and msp.total_vle_clicks < 200
            then 'High Risk'

        when msp.average_assessment_score < 50
            then 'Medium Risk'

        else 'Low Risk'

    end as risk_level

from {{ ref('mart_student_performance') }} msp

join {{ ref('dim_students') }} ds
    on msp.student_id = ds.student_id

join {{ ref('dim_modules') }} dm
    on msp.module_id = dm.module_id

join {{ ref('dim_module_presentations') }} dp
    on msp.presentation_id = dp.presentation_id

where

    msp.average_assessment_score < 50

order by

    risk_level,
    average_score;