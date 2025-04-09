# Ethereum-Block-Analytics

##  **Project Overview**

This project implements a **data engineering pipeline** for ingesting, processing, and analyzing **Ethereum block data**. The pipeline automates the process of tracking miner activity, block sizes, gas limits, and rewards over time. It uses modern cloud technologies, data warehousing, and orchestration to provide real-time insights into blockchain performance.

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

Open **Power BI** (or your preferred dashboard tool) to view the visualizations:

- Miner Activity: Top miners by total rewards
- Gas Limit Trends: Gas limits over time

---

## 🛠️ **Project Workflow**

1. **Data Ingestion**: Ethereum block data is ingested in **batch mode** from an external source to **Google Cloud Storage (GCS)**.
2. **Orchestration**: The pipeline is fully orchestrated using **Apache Airflow**, which automates the data ingestion, transformation, and loading processes.
3. **Data Warehouse**: Processed data is loaded into **BigQuery** where it is partitioned and clustered for optimized querying.
4. **Transformations**: Data transformations, including time extraction and miner aggregation, are performed using **dbt**.
5. **Visualization**: Key insights such as miner performance and gas usage trends are displayed on a **Power BI** dashboard.

---

## 💡 **Key Features**

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

##  **Future Enhancements**

- **Real-Time Data**: Implement streaming data ingestion using **Kafka** or **Google Pub/Sub** to capture real-time Ethereum blockchain data.
- **Advanced Analytics**: Add more complex transformations to analyze transaction fees, block propagation times, or miner rewards by time of day.
- **Machine Learning**: Build models to predict future gas limits or miner performance based on historical data.

---

##  **Contributing**

Feel free to open an issue or submit a pull request if you'd like to contribute to the project.

---
