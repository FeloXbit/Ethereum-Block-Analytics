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
