### 1️⃣ Infrastructure Setup – Terraform  

📌 **Goal**: Automate the provisioning of all Google Cloud resources needed by the pipeline, including:

- A **Google Cloud Storage (GCS)** bucket to stage raw data
- A **BigQuery** dataset to store and analyze Ethereum blockchain data

---

#### 🧱 What It Provisions:

| Resource             | Name                                |
|----------------------|-------------------------------------|
| GCS Bucket           | `ethereum-block-analytics-data`     |
| BigQuery Dataset     | `ethereum_data`                     |
| Project              | `top-design-455621-h9`              |
| Region               | `us-central1`                       |

---

#### 🗂️ Files and Their Roles

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
     bucket_name = "ethereum-block-analytics-data"
     ```

2. **Resource Provisioning (`main.tf`)**

   ```hcl
   resource "google_storage_bucket" "ethereum_data_bucket" {
     name          = var.bucket_name
     location      = var.region
     force_destroy = true
   }

   resource "google_bigquery_dataset" "ethereum_dataset" {
     dataset_id                  = var.dataset_name
     location                    = var.region
     delete_contents_on_destroy = true
   }
   ```

   - Provisions both the staging bucket and the data warehouse dataset.

4. **Deployment Outputs (`outputs.tf`)**

   ```hcl
   output "bucket_name" {
     value = google_storage_bucket.ethereum_data_bucket.name
   }
   ```

   - Outputs the names of your deployed GCP resources in the console.

---

#### Deployment Steps

Run the following commands inside the `terraform/` directory:

```bash
terraform init         # Initialize Terraform
terraform plan         # Preview the infrastructure changes
terraform apply        # Deploy GCS & BigQuery
```

After a successful run, Terraform will provision all required GCP infrastructure and print the resource names as confirmation.

---


