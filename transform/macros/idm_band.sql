{% macro idm_band(column_name, bound) %}

{% if bound == "lower" %}

case
    when {{ column_name }} like '%-%'
        then split_part({{ column_name }}, '-', 1)::int
    else null
end

{% elif bound == "upper" %}

case
    when {{ column_name }} like '%-%'
        then regexp_replace(
            split_part({{ column_name }}, '-', 2),
            '[^0-9]',
            '',
            'g'
        )::int
    else null
end

{% endif %}

{% endmacro %}