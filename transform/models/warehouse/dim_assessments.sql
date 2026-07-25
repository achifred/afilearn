{{
    config(
        materialized = 'incremental',
        unique_key = 'assessment_id'
    )
}}

select
    {{ dbt_utils.generate_surrogate_key('assessment_id')}} as assessment_id,
    sa.assessment_id as assessment_code,
    dp.presentation_id,
    sa.assessment_type,
    sa.submission_date_offset,
    sa.assessment_weight,
    current_timestamp as created_at,
    current_timestamp as updated_at
from {{ ref('stg_assessments') }} sa
inner join {{ ref('dim_modules') }}  dm on sa.module_code = dm.module_code
inner join {{ ref('dim_presentations') }}  dp 
on dm.module_id = dp.module_id and dp.presenatation_code = sa.presenatation_code