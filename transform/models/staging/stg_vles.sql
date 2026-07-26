{{ config(
    materialized ='view'
) }}

select distinct
    id_site::int as site_id,
    trim(code_module) as module_code,
    trim(code_presentation) as presenatation_code,
    activity_type,
    {{ null_resolver('week_from','int') }} as week_from,
    {{ null_resolver('week_to','int') }} as week_to
from {{ source('raw', 'vles') }}