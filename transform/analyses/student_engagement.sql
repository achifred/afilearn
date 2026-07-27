select

    case
        when total_vle_clicks < 200 then 'Low Engagement'
        when total_vle_clicks between 200 and 1000 then 'Medium Engagement'
        else 'High Engagement'
    end as engagement_level,

    count(*) as total_students,

    round(avg(average_assessment_score), 2) as average_score,

    round(avg(
        case
            when final_result in ('Pass', 'Distinction')
            then 1
            else 0
        end
    ) * 100, 2) as pass_rate

from {{ ref('mart_student_performance') }}

group by engagement_level

order by average_score;