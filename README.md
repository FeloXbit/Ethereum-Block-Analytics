# Ethereum Block Analytics Pipeline

[![Ethereum Block Analytics Pipeline Repository](https://img.shields.io/badge/Repository-Github-blue)](https://github.com/FeloXbit/Ethereum-Block-Analytics)

##  **Project Overview**

This project implements a **data engineering pipeline** for ingesting, processing, and analyzing **Ethereum block data**. The pipeline automates the process of tracking miner activity, block sizes, gas limits, and rewards over time. It uses modern cloud technologies, data warehousing, and orchestration to provide real-time insights into blockchain performance.

---

## **Problem Statement**

The Ethereum blockchain produces vast amounts of block data every day. This data contains valuable insights about:
Network performance (gas usage, block size, transaction throughput)
Miner behavior and rewards
Congestion patterns and trends over time

However, raw blockchain data is difficult to consume and analyze due to its volume, structure, and complexity. This project aims to:
Solve the challenge of extracting meaningful, queryable insights from Ethereum block data by building an automated, scalable, and cloud-native data pipeline.

## **What the Project Does**

![Data Architecture drawio (1)](https://github.com/user-attachments/assets/c6322471-c10e-4f37-b25c-74784304d1c4)


Extracts block-level data from the Ethereum network.

Transforms the raw data into a structured format.

Loads the transformed data into BigQuery.

Visualizes metrics and trends for further analysis.

##  **Project Folder Structure**

This repository follows the folder structure outlined below:

```
ethereum-block-analytics/
├── dags/                      # Apache Airflow DAGs for orchestration
│   ├── ethereum_block_ingestion.py  # Ingest Ethereum block data
│   ├── data_transformation.py      # Transform raw data using dbt
│   └── load_to_bigquery.py        # Load processed data into BigQuery
│
├── dbt/                       # dbt models and configurations
│   ├── models/                 # SQL transformations (fact & dimension tables)
│   │   ├── staging/            # Staging models
│   │   │   └── stg_staging__ethereum_transactions.sql
│   │   ├── dim_miners.sql      # Miner dimension model
│   │   ├── dim_time.sql        # Time dimension model
│   │   ├── fact_ethereum_blocks.sql # Main block data aggregation model
│   │   └── schema.yml          # Source and model documentation
│   ├── macros/                 # Custom dbt macros
│   │   └── get_miner_name_description.sql
│   ├── seeds/                  # Static data files (e.g., country codes, etc.)
│   ├── snapshots/              # dbt snapshots for slowly changing dimensions (if applicable)
│   └── dbt_project.yml         # dbt configuration file
│
├── notebooks/                 # Jupyter Notebooks for exploration or debugging
│   ├── data_exploration.ipynb  # Exploratory data analysis (EDA) on Ethereum blocks
│   └── ...
│
├── data/                      # Raw and processed data (optional, could be excluded in favor of GCS)
│   ├── raw_data/               # Store raw Ethereum block data before processing
│   └── processed_data/         # Store processed data ready for analysis
│
├── dashboards/                # Power BI / Tableau dashboard reports
│   ├── ethereum_dashboard.pbix  # Power BI report file (or exported images, templates)
│   └── ...
│
├── docker/                    # Docker-related files (optional)
│   ├── Dockerfile             # Dockerfile for containerizing the pipeline
│   └── docker-compose.yml     # Docker Compose file (if needed)
│
├── terraform/
│    ├── main.tf                # Terraform configuration for GCP infrastructure
│   ├── variables.tf           # Variables for GCP resources
│   └── outputs.tf             # Output configuration for GCP resources          
│

 

```

---

##  **Technologies Used**

- **Cloud Infrastructure**: Google Cloud Platform (GCP)
- **Orchestration**: Apache Airflow
- **Data Warehouse**: BigQuery
- **Data Transformation**: dbt (Data Build Tool)
- **Visualization**: Power BI / Tableau
- **Infrastructure as Code (IaC)**: Terraform
- **Containerization**: Docker (optional)

---

## **Infrastructure Setup**
### Infrastructure Setup – Terraform  

 **Goal**: Automate the provisioning of all Google Cloud resources needed by the pipeline, including:

- A **Google Cloud Storage (GCS)** bucket to stage raw data
- A **BigQuery** dataset to store and analyze Ethereum blockchain data

---

#### What It Provisions:

| Resource             | Name                                |
|----------------------|-------------------------------------|
| GCS Bucket           | `ethereum-block-analytics-data`     |
| BigQuery Dataset     | `ethereum_data`                     |
| Project              | `top-design-455621-h9`              |
| Region               | `us-central1`                       |

---

#### Files and Their Roles

| File | Purpose |
|------|--------|
| `variables.tf`      | Declares configurable values like project ID, region, and resource names |
| `terraform.tfvars`  | Supplies actual values to the declared variables |
| `main.tf`           | Provisions the GCS bucket and BigQuery dataset |

---

#### How It Works


1. **Variables Setup (`variables.tf` + `terraform.tfvars`)**
```hcl
variable "credentials" {
  description = "Path to the GCP credentials JSON file"
  default = "./top-design-455621-h9-66e5948e961a.json"
}

variable "project_id" {
  description = "GCP Project ID"
  default = "top-design-455621-h9"
}

variable "bucket_name" {
  description = "GCS Bucket Name for storing Ethereum Block Analytics data"
  default = "ethereum-block-analytics-data"
}

variable "bucket_location" {
  description = "Location of the GCS bucket"
  default = "US"
}

variable "dataset_id" {
  description = "BigQuery Dataset ID for Ethereum data"
  default = "ethereum_data"
}

variable "table_id" {
  description = "BigQuery Table ID for Ethereum transactions"
  default = "ethereum_transactions"
}

variable "gcs_bucket_name" {
  description = "GCS Bucket Name for Ethereum Analytics"
  default = "Eth-analytics"
}

variable "gcs_storage_class" {
  description = "Storage class for the GCS bucket"
  default = "STANDARD"
}

variable "dataproc_cluster_name" {
  description = "Dataproc Cluster Name"
  default = "Eth-analytics-cluster"
}

variable "dataproc_machine_type" {
  description = "Machine type for Dataproc cluster nodes"
  default = "n1-standard-2"
}

variable "dataproc_image_version" {
  description = "Dataproc image version"
  default = "2.1-debian10"
}

 ```

   - You set actual values like this in `terraform.tfvars`:

  ```hcl    
credentials            = "./top-design-455621-h9-66e5948e961a.json"
project_id            = "top-design-455621-h9"
bucket_name           = "ethereum-block-analytics-data"
bucket_location       = "US"
dataset_id            = "ethereum_data"
table_id              = "ethereum_transactions"
gcs_bucket_name       = "Eth-analytics"
gcs_storage_class     = "STANDARD"
dataproc_cluster_name = "Eth-analytics-cluster"
dataproc_machine_type = "n1-standard-2"
dataproc_image_version = "2.1-debian10"
```

2. **Resource Provisioning (`main.tf`)**

 ```hcl
  
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.19.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}

# GCS Data Lake Storage Bucket
resource "google_storage_bucket" "ethereum_block" {
  name          = var.gcs_bucket_name
  location      = var.location
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 30  
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

# Create a directory for temporary files of Dataflow
resource "google_storage_bucket_object" "dataflow_temp_folder" {
  name    = "temp/"
  content = "temp folder for dataflow"
  bucket  = google_storage_bucket.ethereum_block.name
}

# Create a directory for Dataflow staging files
resource "google_storage_bucket_object" "dataflow_staging_folder" {
  name    = "staging/"
  content = "staging folder for dataflow"
  bucket  = google_storage_bucket.ethereum_block.name
}

# BigQuery Dataset - Raw Data
resource "google_bigquery_dataset" "raw_dataset" {
  dataset_id = var.raw_dataset_name
  location   = var.location
}

# BigQuery Dataset - Processed Data
resource "google_bigquery_dataset" "processed_dataset" {
  dataset_id = var.processed_dataset_name
  location   = var.location
}

# BigQuery raw data table
resource "google_bigquery_table" "carpark_availability_table" {
  dataset_id = google_bigquery_dataset.raw_dataset.dataset_id
  table_id   = "carpark_availability"
  deletion_protection = false

  time_partitioning {
    type  = "DAY"
    field = "timestamp"
  }

  schema = <<EOF
[
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "REQUIRED"
  },
  {
    "name": "CarParkID",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "Area",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "Development",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "Location",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "Latitude",
    "type": "FLOAT",
    "mode": "NULLABLE"
  },
  {
    "name": "Longitude",
    "type": "FLOAT",
    "mode": "NULLABLE"
  },
  {
    "name": "AvailableLots",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "LotType",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "Agency",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "ingestion_time",
    "type": "TIMESTAMP",
    "mode": "REQUIRED"
  },
  {
    "name": "processing_time",
    "type": "TIMESTAMP",
    "mode": "REQUIRED"
  }
]
EOF
}


 ```

   - Provisions both the staging bucket and the data warehouse dataset.


#### Deployment Steps

Run the following commands inside the `terraform/` directory:

```bash
terraform init         # Initialize Terraform
terraform plan         # Preview the infrastructure changes
terraform apply        # Deploy GCS & BigQuery
```

After a successful run, Terraform will provision all required GCP infrastructure and print the resource names as confirmation.

---

Perfect. Here's the next section for your README:

---

### Data Ingestion – Python Scripts  


 **Goal**: Fetch Ethereum block and transaction data from a public API and store it in Google Cloud Storage (GCS) as CSV files.

---

#### Workflow

```
Ethereum Node API ➝ Python Ingestion Scripts ➝ GCS (Staging Layer)
```

---

####  How It Works

Your ingestion scripts are built to work with a Kaggle dataset and simulate pulling from an Ethereum node:

- **Source Dataset**: Kaggle Dataset: `muhammedabdulazeem/ethereum-block-data`
- **Library Used**: `kagglehub` to download structured blockchain data.
- **Storage**: Processed files are saved in `data/` then uploaded to GCS bucket: `ethereum-block-analytics-data`.

---

#### Key Files & What They Do

| File | Description |
|------|-------------|
| `download_data.py` | Downloads raw Ethereum block data from Kaggle to the local `data/` folder |
| `upload_to_gcs.py` | Uploads the downloaded data to your GCS bucket |
| `config.py` | Stores bucket name and folder path config |
| `requirements.txt` | Python dependencies for ingestion scripts |

---

####  Usage

1. **Download the Data from Kaggle**

```bash
python ethereum_block_ingestion/download_data.py
```

2. **Upload to GCS Bucket**

```bash
python ethereum_block_ingestion/upload_to_gcs.py
```

> Make sure your GCP credentials JSON file path is set in the script or as an environment variable.

---

#### Behind the Scenes: `upload_to_gcs.py`

```python
from google.cloud import storage

def upload_to_gcs(bucket_name, source_file, destination_blob):
    client = storage.Client()
    bucket = client.bucket(bucket_name)
    blob = bucket.blob(destination_blob)
    blob.upload_from_filename(source_file)
```

- This script initializes a GCS client and uploads each file from `data/` to your staging bucket.

---

#### Outcome

Once complete, raw CSV files representing Ethereum blocks and transactions will be available in GCS and ready for loading into BigQuery.

---
Awesome, here comes the **Apache Airflow orchestration section** for your README:

---

### Workflow Orchestration – Apache Airflow   

 **Goal**: Automate and schedule the entire pipeline—from data ingestion to loading and transformation—using **Apache Airflow** running in Docker.

---

#### Dockerized Airflow Setup

Your Airflow instance is containerized using **Docker Compose**, making local orchestration seamless and production-ready.

| Service         | Purpose                    |
|-----------------|----------------------------|
| `webserver`     | UI access to monitor DAGs  |
| `scheduler`     | Schedules and runs tasks   |
| `postgres`      | Metadata DB for Airflow    |
| `redis`         | Queue for Celery executor  |
| `worker`        | Executes tasks asynchronously |
| `triggerer`     | Supports deferrable operators (Airflow 2.2+) |

---

#### Folder & Files

| File | Description |
|------|-------------|
| `docker-compose.yml` | All Airflow services and volumes |
| `requirements.txt`        | Dependencies for airflow |
| `dags/ethereum_block_ingestion.py` | DAG for ingestion(ETL), loads to BigQuery |

---

#### How It Works

1. **Startup Airflow**

```bash
docker-compose up airflow-init     # Initializes metadata DB
docker-compose up                  # Starts all services
```

2. **Access the Web UI**

- Navigate to `http://localhost:8080`
- Use credentials from `.env` (default: `airflow` / `airflow`)
- Trigger your DAGs manually or watch them run on schedule

---

#### DAG: `ethereum_block_ingestion.py`

```python
@dag(schedule_interval="@daily", ...)
def ethereum_ingestion():
    download_task = PythonOperator(...)
    upload_task = PythonOperator(...)
```

- Automates downloading and uploading Ethereum block data.

---

#### Outcome

Airflow ensures each part of the pipeline runs reliably and on schedule. You get automatic retries, logging, and visibility into your entire ETL process.

---

### Data Loading – BigQuery  

---

#### Workflow

```
GCS (Staging Layer) ➝ BigQuery (Raw Tables)
```

---

#### Folder Contents

| File | Description |
|------|-------------|
| `load_to_bigquery.py` | Python function to load data from GCS to BigQuery |
| `schema.json` | BigQuery table schema definition |
| `utils.py` | Utility functions used across pipeline |

---

#### Usage

This logic is triggered as part of the Airflow DAG (`load_to_bigquery.py`), but you can run it independently like this:

```bash
python load_to_bigquery/load_to_bigquery.py
```

> Ensure you’ve authenticated using your GCP service account JSON.

---

#### Key Function: `load_to_bigquery()`

```python
def load_to_bigquery(bucket_name, source_file, dataset_id, table_id):
    client = bigquery.Client()
    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.CSV,
        schema=your_schema_here,
        skip_leading_rows=1,
        autodetect=True
    )
    uri = f"gs://{bucket_name}/{source_file}"
    load_job = client.load_table_from_uri(uri, f"{dataset_id}.{table_id}", job_config=job_config)
```

- Loads a file from GCS directly into a BigQuery table
- Autodetects schema or uses the provided `schema.json`

---

#### 🗄️ Dataset & Table Info

| Dataset | `ethereum_data` |
|---------|-----------------|
| Tables  | `ethereum_transactions` (you can add more e.g., `blocks`, `contracts`) |

---

#### Outcome

Your raw Ethereum data is now available in **BigQuery**, serving as the single source of truth for downstream transformation and analytics.

---
Great! Here's the **dbt transformation** step of your README:

---

### Data Transformation – dbt  

# Built with dbt on BigQuery

This project transforms raw Ethereum transaction data into an analytical dataset of block-level insights using [dbt](https://www.getdbt.com/) and Google BigQuery. It includes staging, fact/dimension modeling, and documentation generation.

---
![dbt-dag](https://github.com/user-attachments/assets/e9be82a2-a94d-4f89-9291-5d920656eb8b)


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
---
## **Visualization in Looker Studio**


## Ethereum Block Analytics Dashboard

### Ethereum Block Overview
![Overview](https://github.com/user-attachments/assets/340aff82-5928-48e1-82a7-903e8a17de87)


- **Block Time (sec) Over Time**  
  The average block time remains within the 13–15 second range across the observed period, showing consistent block production.

- **Block Reward Over Time**  
  Block rewards decrease steadily, reflecting changes from protocol upgrades and updates to Ethereum’s monetary policy.

- **Total Transactions**  
  A total of 14.9 million transactions are covered, capturing extensive on-chain activity.

- **Average Gas Price**  
  The overall average gas price is 0.62, offering a benchmark for typical transaction costs during the covered period.

- **Top Miners**  
  Mining activity is dominated by:
  - Ethermine: 40.3%  
  - SparkPool_3: 38.8%  
  - F2Pool_2: 20.9%

---

### Gas Market & Transaction Metrics
![Gas Market](https://github.com/user-attachments/assets/d005385a-3a7d-4869-a37b-8aa13804fe23)


- **Average Gas Price Over Time**  
  Distinct spikes in gas price are observed between September 2020 and May 2021, corresponding to periods of increased network usage.

- **Highest Gas Usage Blocks**  
  The top blocks by gas usage all reached close to the block gas limit (~15M), with block rewards mostly above 2 ETH. This suggests high transaction throughput or smart contract execution in those blocks.

---

##  **Project Setup**

### 1. Clone the Repository

```bash
git clone https://github.com/FeloXbit/Ethereum-Block-Analytics
cd ethereum-block-analytics
```

### 2. Set Up Cloud Infrastructure

Use **Terraform** to provision Google Cloud resources (e.g., GCS, BigQuery):

```bash
terraform init
terraform apply
```

### 3. Install Dependencies

Install the required Python packages:

```bash
pip install -r requirements.txt
```

Make sure to configure your Google Cloud credentials for **BigQuery** and **GCS**.

### 4. Run the Data Pipeline

You can trigger the data pipeline through **Apache Airflow**:

- Start the Airflow scheduler and webserver:

```bash
airflow scheduler
airflow webserver
```

- The DAG will automatically ingest Ethereum block data from an external source, store it in **Google Cloud Storage**, and load it into **BigQuery** for processing.

Alternatively, you can manually run the DAG tasks in the **Airflow UI**.

### 5. Run dbt Models

After the data is loaded into BigQuery, use **dbt** to perform transformations:

```bash
dbt run
```

### 6. View the Dashboard

Open **Looker Studio** (or your preferred dashboard tool) to view the visualizations:

- Miner Activity: Top miners by total rewards
- Gas Limit Trends: Gas limits over time

---

##  **Project Workflow**

1. **Data Ingestion**: Ethereum block data is ingested in **batch mode** from an external source to **Google Cloud Storage (GCS)**.
2. **Orchestration**: The pipeline is fully orchestrated using **Apache Airflow**, which automates the data ingestion, transformation, and loading processes.
3. **Data Warehouse**: Processed data is loaded into **BigQuery** where it is partitioned and clustered for optimized querying.
4. **Transformations**: Data transformations, including time extraction and miner aggregation, are performed using **dbt**.
5. **Visualization**: Key insights such as miner performance and gas usage trends are displayed on a **Power BI** dashboard.

---

##  **Key Features**

- **Cloud-Based**: Fully hosted on **Google Cloud Platform (GCP)** for scalability and reliability.
- **Automated Pipelines**: The ingestion, transformation, and loading processes are automated and orchestrated using **Airflow**.
- **Data Transformation**: Data is transformed using **dbt**, ensuring maintainable, versioned, and reproducible models.
- **Real-Time Insights**: The data is updated daily to provide up-to-date blockchain analytics.
- **Optimized Data Warehouse**: BigQuery tables are partitioned and clustered for fast querying, making it easy to generate insights from millions of records.

---

##  **Dashboard Features**

The dashboard includes the following metrics:

- **Miner Activity**: Visualize top miners based on the total rewards they earned.
- **Gas Limit Trends**: Track the gas limit changes over time, identifying periods of high gas usage.

---

##  **Reproducibility Instructions**

1. **Clone the repository**:

```bash
git clone https://github.com/FeloXbit/Ethereum-Block-Analytics
cd ethereum-block-analytics
```

2. **Set up cloud resources** (GCS, BigQuery):

```bash
terraform init
terraform apply
```

3. **Install required Python packages**:

```bash
pip install -r requirements.txt
```

4. **Run Airflow** to start the data pipeline:

```bash
airflow scheduler
airflow webserver
```

5. **Run dbt models**:

```bash
dbt run
```

6. **Open the dashboard** in Power BI or Tableau to visualize the results.

---

##  **Contributing**

Feel free to open an issue or submit a pull request if you'd like to contribute to the project.

---
