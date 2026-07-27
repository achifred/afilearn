select

    vat.vle_activity_type,

    count(*) as interactions,

    round(avg(fsa.score), 2) as average_score,

    sum(fsv.sum_click) as total_clicks

from {{ ref('fact_student_vles') }} fsv

join {{ ref('dim_vles') }} dv
    on fsv.vle_id = dv.vle_id

join {{ ref('dim_vle_activity_types') }} vat
    on dv.vle_activity_type_id = vat.vle_activity_type_id

join {{ ref('fact_student_assessments') }} fsa
    on fsv.student_id = fsa.student_id

group by vat.vle_activity_type

order by average_score desc;