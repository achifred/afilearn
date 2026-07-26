{{
    config(
        materialized = 'incremental',
        unique_key = 'assessment_id',
        on_schema_change='append_new_columns'
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['assessment_id'])}} as assessment_id,
    sa.assessment_id as assessment_code,
    dp.presentation_id,
    sa.assessment_type,
    sa.submission_date_offset,
    sa.assessment_weight,
    current_timestamp::timestamp as created_at,
    current_timestamp::timestamp as updated_at
from {{ ref('stg_assessments') }} sa
inner join {{ ref('dim_modules') }}  dm on sa.module_code = dm.module_code
inner join {{ ref('dim_module_presentations') }}  dp 
on dm.module_id = dp.module_id and dp.presentation_code = sa.presentation_code