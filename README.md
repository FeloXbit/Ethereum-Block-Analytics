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
