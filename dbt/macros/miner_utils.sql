{% macro get_miner_name_description(miner_name) %}
    case
        when lower({{ miner_name }}) like '%btc%' then 'BTC.com'
        when lower({{ miner_name }}) like '%huobi%' then 'HuobiPool'
        when lower({{ miner_name }}) like '%viabtc%' then 'ViaBTC'
        when lower({{ miner_name }}) like '%fire%' then 'FirePool'
        when lower({{ miner_name }}) like '%mineral%' then 'Minerall.io'
        else 'Other'
    end
{% endmacro %}
