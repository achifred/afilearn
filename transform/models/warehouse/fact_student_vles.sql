{{ config(
    materialized = 'incremental',
    unique_key = 'student_vle_id'
) }}

select
    {{ dbt_utils.generate_surrogate_key(['student_id','vle_id']) }} as student_vle_id,
    ds.student_id,
    dv.vle_id,
    sv.access_date_offset,
    sv.sum_click,
    current_timestamp as created_at,
    current_timestamp as updated_at
from {{ ref('stg_student_vles') }} sv
inner join {{ ref('dim_students') }} ds on sv.student_id = ds.student_number
inner join {{ ref('dim_vles') }} dv on sv.vle_id = dv.site_id