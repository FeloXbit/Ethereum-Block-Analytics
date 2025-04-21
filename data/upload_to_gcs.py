import os
from google.cloud import storage
from config import GCS_BUCKET_NAME, GCS_FOLDER_PATH

def upload_to_gcs(local_file_path, destination_blob_name):
    client = storage.Client()
    bucket = client.get_bucket(GCS_BUCKET_NAME)
    blob = bucket.blob(GCS_FOLDER_PATH + destination_blob_name)
    blob.upload_from_filename(local_file_path)

def upload_data():
    local_data_folder = 'data/'
    for filename in os.listdir(local_data_folder):
        file_path = os.path.join(local_data_folder, filename)
        upload_to_gcs(file_path, filename)

if __name__ == '__main__':
    upload_data()
