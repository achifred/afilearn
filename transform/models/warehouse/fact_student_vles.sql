{{ config(
    materialized = 'incremental',
    unique_key = 'student_vle_id',
    on_schema_change='append_new_columns'
) }}

with numbered_student_vles as (
select
    ds.student_id,
    dv.vle_id,
    sv.access_date_offset,
    sv.sum_click,
    dv.presentation_id,
    row_number() over (
            partition by ds.student_id, dv.vle_id, dv.presentation_id, sv.access_date_offset 
            order by sv.sum_click desc 
        ) as event_occurrence_index

from {{ ref('stg_student_vles') }} sv
inner join {{ ref('dim_students') }} ds on sv.student_id = ds.student_number
inner join {{ ref('dim_vles') }} dv on sv.site_id = dv.site_id
)

select
    {{ dbt_utils.generate_surrogate_key(['student_id','vle_id','presentation_id','access_date_offset','event_occurrence_index']) }} as student_vle_id,
    student_id,
    vle_id,
    access_date_offset,
    sum_click,
    current_timestamp::timestamp as created_at,
    current_timestamp::timestamp as updated_at
from numbered_student_vles