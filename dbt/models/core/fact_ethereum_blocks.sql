{{
    config(
        materialized='table'
    )
}}

with base as (
    

    select *
    from {{ ref('stg_staging__ethereum_transactions') }}
    where created_ts is not null --line of code added
),

-- Join with dim_miners to get descriptive miner details
miner_join as (
    select
       b.*,
       m.miner_id  --join key fro dim_miners for miner-related analysis
    from base b
    left join {{ ref('dim_miners') }} m
       on b.miner_hash = m.miner_hash
    
),

-- Join with dim_time to get date/time breakdowns
time_join as (
    select
       mj.*,
       t.time_id  -- Join key from dim_time for time based analysis
    from miner_join mj
    left join {{ ref("dim_time") }} t
        on mj.created_ts = t.block_timestamp

)

-- Final fact table selecting relevant fields
select
    -- Surrogate key to uniquely identify each block
    {{ dbt_utils.generate_surrogate_key(["block_height","block_hash"]) }} as block_key,

    block_height,
    block_hash,

    created_ts,
    block_time_in_sec,

    total_tx,
    block_size,
    block_reward,
    total_uncle,
    gas_used,
    gas_limit,
    gas_avg_price

from time_join    
        
       
