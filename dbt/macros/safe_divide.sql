-- This macro performs a safe division to avoid divide-by-zero or null errors.
    -- Parameters:
    --   numerator: The value you want to divide (e.g., gas_used)
    --   denominator: The value to divide by (e.g., gas_limit)

{% macro safe_divide(numerator, denominator, default=0) %}
    case 
        when {{ denominator }} is null or {{ denominator }} = 0 then {{ default }}
        else {{ numerator }} / {{ denominator }}
    end
{% endmacro %}
