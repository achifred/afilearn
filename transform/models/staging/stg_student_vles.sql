{{ config(
    materialized ='view'
) }}

select distinct
    trim(code_module) as module_code,
    trim(code_presentation) as presenatation_code,
    id_student::int as student_id,
    id_site::int as site_id,
    "date"::int as access_date_offset,
    sum_click::int as sum_click
from {{ source('raw', 'student_vles') }}