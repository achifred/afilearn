import os
from dotenv import load_dotenv

load_dotenv()

BATCH_SIZE = os.getenv("BATCH_SIZE")
DATA_ROOT_PATH = os.getenv("DATA_ROOT_PATH")
FAILED_DATA_PATH = os.getenv("FAILED_DATA_PATH")
PROCESSED_DATA_PATH = os.getenv("PROCESSED_DATA_PATH")

DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")

MAX_LOG_FILE_SIZE = 10 * 1024 * 1024
