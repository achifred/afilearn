{% macro is_passed(column_name) %}

{% set failed_values = ('withdraw','fail') %}
{% set passed_values = ('pass','distinction') %}

case
    when {{ column_name }} is null then false
    
    when lower(trim({{ column_name }})) in {{ failed_values }} then false

    when lower(trim({{ column_name }})) in {{ passed_values }} then true

    else false
end

{% endmacro %}