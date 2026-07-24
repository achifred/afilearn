{{ config(
    materialized = 'view'
) }}

select
    trim(code_module) as module_code,
    trim(code_presentation) as presenatation_code,
    id_assessment::int as assessment_id,
    trim(assessment_type) as assessment_type,
    "date"::int as submission_date_offset,
    weight::int as assessment_weight
from {{ source('raw', 'assessment') }}