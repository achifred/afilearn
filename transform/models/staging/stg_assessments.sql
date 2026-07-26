{{ config(
    materialized = 'view'
) }}

select
    trim(code_module) as module_code,
    trim(code_presentation) as presenatation_code,
    trim(id_assessment) as assessment_id,
    trim(assessment_type) as assessment_type,
    {{ null_resolver('"date"', 'int') }} as submission_date_offset,
    weight::numeric(4,1) as assessment_weight
from {{ source('raw', 'assessments') }}