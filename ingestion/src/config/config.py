import os
from load.load_student_data import load_student_data
from load.load_coursese_data import load_courses_data
from load.load_assessments_data import load_assessments_data
from load.load_student_assessment_data import load_student_assessment_data
from load.load_student_registration_data import load_student_registration_data
from load.load_student_vle_data import load_student_vle_data
from load.load_vle_data import load_vle_data

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

LOAD_PIPELINE = [
    {
        "name": "student info",
        "function": load_student_data
    },
    {
        "name": "courses",
        "function": load_courses_data
    },
    {
        "name": "assessments",
        "function": load_assessments_data
    },
    {
        "name": "student assessments",
        "function": load_student_assessment_data
    },
    {
        "name": "student registrations",
        "function": load_student_registration_data
    },
    {
        "name": "student vle",
        "function": load_student_vle_data
    },
    {
        "name": "vle",
        "function": load_vle_data
    }
]