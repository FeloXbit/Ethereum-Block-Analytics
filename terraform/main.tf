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
resource "google_bigquery_table" "ethereum_transactions_table" {
  dataset_id = google_bigquery_dataset.raw_dataset.dataset_id
  table_id   = "ethereum_transactions"
  deletion_protection = false

  time_partitioning {
    type  = "DAY"
    field = "timestamp"
  }

  schema = <<EOF
[
    { name = "id",                 type = "INTEGER", mode = "NULLABLE" },
    { name = "block_height",      type = "INTEGER", mode = "NULLABLE" },
    { name = "block_hash",        type = "STRING",  mode = "NULLABLE" },
    { name = "created_ts",        type = "INTEGER", mode = "NULLABLE" },
    { name = "time_in_sec",       type = "INTEGER", mode = "NULLABLE" },
    { name = "miner_hash",        type = "STRING",  mode = "NULLABLE" },
    { name = "block_reward",      type = "FLOAT",   mode = "NULLABLE" },
    { name = "block_size",        type = "INTEGER", mode = "NULLABLE" },
    { name = "total_uncle",       type = "INTEGER", mode = "NULLABLE" },
    { name = "total_tx",          type = "INTEGER", mode = "NULLABLE" },
    { name = "gas_used",          type = "INTEGER", mode = "NULLABLE" },
    { name = "gas_limit",         type = "INTEGER", mode = "NULLABLE" },
    { name = "gas_avg_price",     type = "FLOAT",   mode = "NULLABLE" },
    { name = "block_time_in_sec", type = "INTEGER", mode = "NULLABLE" },
    { name = "miner_name",        type = "STRING",  mode = "NULLABLE" },
    { name = "miner_icon_url",    type = "STRING",  mode = "NULLABLE" }
]
EOF
}

