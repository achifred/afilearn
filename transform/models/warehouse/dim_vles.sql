{{
    config(
        materialized = 'incremental',
        unique_key = 'vle_id'
    )  
}}


select
    {{ dbt_utils.dbt_utils.generate_surrogate_key('site_id') }} as vle_id,
    sv.site_id,
    dp.presentation_id,
    dat.vle_activity_type_id,
    sv.week_from,
    sv.week_to,
    current_timestamp as created_at,
    current_timestamp as updated_at
from {{ ref('stg_vles') }} sv
inner join {{ ref('dim_modules') }} dm on sv.module_code = dm.module_code
inner join {{ ref('dim_presentations') }} dp 
on dm.module_id = dp.module_id and dp.presenatation_code = sv.presenatation_code
inner join {{ ref('dim_vle_activity_types') }} dat on sv.activity_type = dat.vle_activity_type