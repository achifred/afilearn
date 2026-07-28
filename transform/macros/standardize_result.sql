{% macro standardize_result(column_name) %}

case
    when trim(lower({{ column_name }})) = 'pass'
        then 'Pass'

    when trim(lower({{ column_name }})) = 'fail'
        then 'Fail'

    when trim(lower({{ column_name }})) = 'withdrawn'
        then 'Withdrawn'

    when trim(lower({{ column_name }})) = 'distinction'
        then 'Distinction'

    else null

end

{% endmacro %}