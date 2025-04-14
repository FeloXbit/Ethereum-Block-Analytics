{{ config(materialized='table') }}

with source_data as (

    select distinct
        -- Select distinct miners from the staging model to avoid duplicates
        miner_hash,
        miner_name,
        miner_icon_url,
        {{ get_miner_name_description('miner_name') }} as standardized_miner_name

    from {{ ref('stg_staging__ethereum_transactions') }}
    where miner_hash is not null

)

select
    {{ dbt_utils.generate_surrogate_key(['miner_hash']) }} as miner_id,
    miner_hash,
    miner_name,
    standardized_miner_name,
    miner_icon_url

from source_data
