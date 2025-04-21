import os
from kaggle.api.kaggle_api_extended import KaggleApi

def download_data():
    api = KaggleApi()
    api.authenticate()

    dataset_name = 'muhammedabdulazeem/ethereum-block-data'
    download_path = 'data/'
    api.dataset_download_files(dataset_name, path=download_path, unzip=True)

if __name__ == '__main__':
    download_data()
