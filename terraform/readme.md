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


