{{ config(
    materialized ='view'
) }}

select distinct
    trim(code_module) as module_code,
    trim(code_presentation) as presentation_code,
    module_presentation_length::int as module_presentation_length
from {{ source('raw', 'courses') }}