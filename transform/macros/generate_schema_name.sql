{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is not none -%}
        {# 🟢 If a custom schema is specified, use ONLY that name #}
        {{ custom_schema_name | trim }}
    {%- else -%}
        {# 🟡 Default fallback to profiles.yml if no custom schema exists #}
        {{ target.schema }}
    {%- endif -%}
{%- endmacro %}