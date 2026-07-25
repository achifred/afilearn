{% macro boolean_resolver(column_name) %}
{% set  true_values = ['1',1,'Y','y','yes','t','T'] %}
case
    when {{ column_name }} is null then false

    when trim({{ column_name }}) in true_values then true
    else false
end
{% endmacro% }