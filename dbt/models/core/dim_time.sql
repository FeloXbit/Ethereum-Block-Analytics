{{ config(materialized='table') }}

with base as (

    select
        created_ts as block_timestamp,
        extract(date from created_ts) as block_date,
        extract(year from created_ts) as year,
        extract(month from created_ts) as month,
        extract(day from created_ts) as day,
        extract(dayofweek from created_ts) as weekday,
        extract(hour from created_ts) as hour

    from {{ ref('stg_staging__ethereum_transactions') }}
    where created_ts is not null

),

deduped as (
    -- Remove duplicate timestamps so each time point appears only once
    select distinct * from base
)

select
    -- Surrogate key for joining with fact table
    {{ dbt_utils.generate_surrogate_key(['block_timestamp']) }} as time_id,
    *

from deduped
