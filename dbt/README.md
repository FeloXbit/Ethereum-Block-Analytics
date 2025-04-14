---


# Built with dbt on BigQuery

This project transforms raw Ethereum transaction data into an analytical dataset of block-level insights using [dbt](https://www.getdbt.com/) and Google BigQuery. It includes staging, fact/dimension modeling, and documentation generation.

---

## How I Built It

### 1. Set up the Environment
- **Platform**: dbt Cloud  
- **Warehouse**: Google BigQuery  
- **Project ID**: `top-design-455621-h9`  
- **Datasets**: `prod` (for models), `staging` (for raw sources)  
- **dbt version**: v1.7+

---

### 2. Source Definition

Defined the raw Ethereum transactions source in `schema.yml`:

```yaml
version: 2

sources:
  - name: staging  
    tables:
      - name: ethereum_transactions
```

---

### 3. Staging Model

Created a staging model to prep the raw data:

```sql
-- models/staging/stg_staging__ethereum_transactions.sql

select * 
from {{ source('staging', 'ethereum_transactions') }}
```

---

### 4. Time Dimension Table

Extracted time components and generated a surrogate key:

```sql
-- models/dim_time.sql

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
  select distinct * from base
)
select
  {{ dbt_utils.generate_surrogate_key(['block_timestamp']) }} as time_id,
  *
from deduped
```

---

### 5. Miner Dimension Table

Extracted distinct miners and standardized their names using a macro:

```sql
-- models/dim_miners.sql

select
  {{ dbt_utils.generate_surrogate_key(['miner_hash']) }} as miner_id,
  miner_hash,
  miner_name,
  {{ get_miner_name_description('miner_name') }} as standardized_miner_name,
  miner_icon_url
from (
  select distinct miner_hash, miner_name, miner_icon_url
  from {{ ref('stg_staging__ethereum_transactions') }}
)
```

Macro for standardizing miner names:

```sql
-- macros/get_miner_name_description.sql

{% macro get_miner_name_description(miner_name) %}
    case
        when {{ miner_name }} like '%Ethermine%' then 'Ethermine'
        -- more standardizations here
        else 'Unknown'
    end
{% endmacro %}
```

---

### 6. Fact Table: `fact_ethereum_blocks`

Joined staging data with dimensions:

```sql
-- models/fact_ethereum_blocks.sql

with base as (
  select * from {{ ref('stg_staging__ethereum_transactions') }}
),
miner_join as (
  select b.*, m.miner_id
  from base b
  left join {{ ref('dim_miners') }} m on b.miner_hash = m.miner_hash
),
time_join as (
  select mj.*, t.time_id
  from miner_join mj
  left join {{ ref("dim_time") }} t on mj.created_ts = t.block_timestamp
)
select
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
```

---

### 7. Running It All

Build all models:

```bash
dbt build
```

**Resolved issues during the process:**
- _Source not found_: fixed by properly defining it in `schema.yml`
- _No data to display_: ensured the staging model had actual rows
- _Quota exceeded_: cleared previous runs and waited for quota reset

---

### 8. Generate & View Documentation

In dbt Cloud:
- Run a job that includes `dbt docs generate`
- Click **“View Documentation”** in the Job run details

Locally:

```bash
dbt docs generate
dbt docs serve
```



### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](https://getdbt.com/community) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
