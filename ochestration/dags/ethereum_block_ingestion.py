import os
import pandas as pd
import kagglehub
from kagglehub import KaggleDatasetAdapter
from google.cloud import bigquery, storage
from google.oauth2 import service_account
from datetime import datetime

# Project config
PROJECT_ID = "top-design-455621-h9"
DATASET_ID = "ethereum_data"
TABLE_ID = "ethereum_transactions"
BUCKET_NAME = "ethereum-block-analytics-data"
GCS_FILE_NAME = "ethereum_block_data.csv"
CREDENTIALS_PATH = "./top-design-455621-h9-66e5948e961a.json"

# Authentication
credentials = service_account.Credentials.from_service_account_file(CREDENTIALS_PATH)
bq_client = bigquery.Client(credentials=credentials, project=PROJECT_ID)
gcs_client = storage.Client(credentials=credentials, project=PROJECT_ID)

# STEP 1: EXTRACT
print("Extracting data from Kaggle...")
df = kagglehub.load_dataset(
    KaggleDatasetAdapter.PANDAS,
    "muhammedabdulazeem/ethereum-block-data",
    file_path="block_data.csv"
)
print("Data extracted. Rows:", len(df))

# STEP 2: TRANSFORM 
print("🛠️ Transforming data...")
df.columns = df.columns.str.strip().str.lower().str.replace(" ", "_")
df['timestamp'] = pd.to_datetime(df['timestamp'], errors='coerce')
df = df.dropna(subset=['block_number', 'timestamp'])
df = df.astype({
    "block_number": "int64",
    "base_fee_per_gas": "float",
    "difficulty": "float",
    "extra_data": "str",
    "gas_limit": "float",
    "gas_used": "float",
    "hash": "str",
    "logs_bloom": "str",
    "miner": "str",
    "mix_hash": "str",
    "nonce": "str",
    "number": "int64",
    "parent_hash": "str",
    "receipts_root": "str",
    "sha3_uncles": "str",
    "size": "float",
    "state_root": "str",
    "timestamp": "datetime64[ns]",
    "total_difficulty": "float",
    "transactions_root": "str",
    "uncle_rewards": "float",
    "transaction_count": "int64"
})
print("✅ Data transformed.")

# STEP 3: LOAD TO GCS 
print("Uploading transformed CSV to GCS...")
local_csv_path = f"/tmp/{GCS_FILE_NAME}"
df.to_csv(local_csv_path, index=False)

bucket = gcs_client.bucket(BUCKET_NAME)
blob = bucket.blob(GCS_FILE_NAME)
blob.upload_from_filename(local_csv_path)

gcs_uri = f"gs://{BUCKET_NAME}/{GCS_FILE_NAME}"
print(f"Uploaded to GCS: {gcs_uri}")

# === STEP 4: LOAD TO BIGQUERY FROM GCS ===
print("Loading CSV to BigQuery from GCS...")

schema = [
    bigquery.SchemaField("block_number", "INTEGER"),
    bigquery.SchemaField("base_fee_per_gas", "FLOAT"),
    bigquery.SchemaField("difficulty", "FLOAT"),
    bigquery.SchemaField("extra_data", "STRING"),
    bigquery.SchemaField("gas_limit", "FLOAT"),
    bigquery.SchemaField("gas_used", "FLOAT"),
    bigquery.SchemaField("hash", "STRING"),
    bigquery.SchemaField("logs_bloom", "STRING"),
    bigquery.SchemaField("miner", "STRING"),
    bigquery.SchemaField("mix_hash", "STRING"),
    bigquery.SchemaField("nonce", "STRING"),
    bigquery.SchemaField("number", "INTEGER"),
    bigquery.SchemaField("parent_hash", "STRING"),
    bigquery.SchemaField("receipts_root", "STRING"),
    bigquery.SchemaField("sha3_uncles", "STRING"),
    bigquery.SchemaField("size", "FLOAT"),
    bigquery.SchemaField("state_root", "STRING"),
    bigquery.SchemaField("timestamp", "TIMESTAMP"),
    bigquery.SchemaField("total_difficulty", "FLOAT"),
    bigquery.SchemaField("transactions_root", "STRING"),
    bigquery.SchemaField("uncle_rewards", "FLOAT"),
    bigquery.SchemaField("transaction_count", "INTEGER"),
]

job_config = bigquery.LoadJobConfig(
    source_format=bigquery.SourceFormat.CSV,
    skip_leading_rows=1,
    schema=schema,
    write_disposition="WRITE_TRUNCATE",
    autodetect=False,
)

load_job = bq_client.load_table_from_uri(
    gcs_uri,
    f"{PROJECT_ID}.{DATASET_ID}.{TABLE_ID}",
    job_config=job_config
)
load_job.result()

print(f" Load complete: {df.shape[0]} rows to {DATASET_ID}.{TABLE_ID}")

#  MAIN FOR AIRFLOW 
def main():
    print(" Running full ETL pipeline: Kaggle ➜ GCS ➜ BigQuery")

if __name__ == "__main__":
    main()
