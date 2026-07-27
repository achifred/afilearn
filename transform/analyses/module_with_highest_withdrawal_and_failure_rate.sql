select

    dm.module_code,

    count(*) as enrolled_students,

    sum(
        case
            when msp.final_result = 'Withdrawn'
            then 1
            else 0
        end
    ) as withdrawals,

    sum(
        case
            when msp.final_result = 'Fail'
            then 1
            else 0
        end
    ) as failures,

    round(
        avg(
            case
                when msp.final_result = 'Withdrawn'
                then 1
                else 0
            end
        ) * 100,
        2
    ) as withdrawal_rate,

    round(
        avg(
            case
                when msp.final_result = 'Fail'
                then 1
                else 0
            end
        ) * 100,
        2
    ) as failure_rate

from {{ ref('mart_student_performance') }} msp

join {{ ref('dim_modules') }} dm
    on msp.module_id = dm.module_id

group by dm.module_code

order by failure_rate desc;