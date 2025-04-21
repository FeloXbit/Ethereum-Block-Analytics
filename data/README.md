# Ethereum Block Analytics

This project involves downloading raw Ethereum block data from Kaggle, uploading it to Google Cloud Storage, and processing it through the pipeline.

## Steps to Run:

1. **Install dependencies**:

    ```bash
    pip install -r requirements.txt
    ```

2. **Configure your Kaggle API**:
    Ensure your Kaggle credentials are set up to access datasets. Follow the instructions [here](https://github.com/Kaggle/kaggle-api).

3. **Configure GCS bucket details** in `scripts/config.py`.

4. **Run the scripts**:
    - Download data from Kaggle: `python scripts/download_data.py`
    - Upload data to GCS: `python scripts/upload_to_gcs.py`
