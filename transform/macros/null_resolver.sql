{% macro null_resolver(column_name, null_maker = '?') %}


case
    when trim({{ column_name }}) = '{{null_maker}}'
        then null

    else {{ column_name }}
end

{% endmacro %}


{% macro null_resolver(column_name, data_type, null_maker = '?') %}


case
    when {{column_name}} is null then null
    when trim({{ column_name }}) = '{{null_maker}}'
        then null

    else cast({{ column_name }} as {{ data_type }})
end

{% endmacro %}
