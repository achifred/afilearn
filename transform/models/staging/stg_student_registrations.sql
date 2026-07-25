{{ config(
    materialized = 'view'
) }}

select
    trim(code_module) as module_code,
    trim(code_presentation) as presenatation_code,
    id_student::int as student_id,
    {{null_resolver('date_registration', 'int')}} as date_registered_offset,
    {{null_resolver('date_unregistration','int')}} as date_unregistered_offset
from {{ source('raw', 'student_registrations') }}