{{
    config(
        materialized='view'
    )
}}

with blockdata as (
    select *,
        row_number() over (partition by block_height) as rn
    from {{ source('staging', 'ethereum_transactions') }}
    where block_height is not null
)

select
    -- Unique block identifier
    {{ dbt_utils.generate_surrogate_key(['block_height', 'block_hash']) }} as block_id,

    -- Block identifiers
    {{ dbt.safe_cast("block_height", api.Column.translate_type("integer")) }} as block_height,
    block_hash,


    -- Block timing
    TIMESTAMP_SECONDS(cast(created_ts as int64)) as created_ts,
    safe_cast(time_in_sec as INT64) as time_in_sec,
    safe_cast(block_time_in_sec as INT64) as block_time_in_sec,


    -- Miner info
    miner_hash,
    miner_name,
    miner_icon_url,

    -- Block stats
    {{ dbt.safe_cast("block_reward", api.Column.translate_type("numeric")) }} as block_reward,
    {{ dbt.safe_cast("block_size", api.Column.translate_type("integer")) }} as block_size,
    {{ dbt.safe_cast("total_uncle", api.Column.translate_type("integer")) }} as total_uncle,
    {{ dbt.safe_cast("total_tx", api.Column.translate_type("integer")) }} as total_tx,
    {{ dbt.safe_cast("gas_used", api.Column.translate_type("integer")) }} as gas_used,
    {{ dbt.safe_cast("gas_limit", api.Column.translate_type("integer")) }} as gas_limit,
    {{ dbt.safe_cast("gas_avg_price", api.Column.translate_type("numeric")) }} as gas_avg_price,

from blockdata
where rn = 1

{% if var('is_test_run', default=false) %}
limit 100
{% endif %}
