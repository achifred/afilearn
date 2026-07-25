{% macro age_band(column_name, bound) %}

{% if bound == "lower" %}

case
    when {{column_name}} is null then null
    when {{ column_name }} like '%-%'
        then split_part({{ column_name }}, '-', 1)::int

    when {{ column_name }} like '%<='
        then regexp_replace({{ column_name }}, '[^0-9]', '', 'g')::int

    else null
end

{% elif bound == "upper" %}

case
    when {{column_name}} is null then null
    when {{ column_name }} like '%-%'
        then split_part({{ column_name }}, '-', 2)::int

    else null
end

{% endif %}

{% endmacro %}