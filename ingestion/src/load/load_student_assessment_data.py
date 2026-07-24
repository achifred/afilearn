from config.databse_config import db_connection_pool
from config.column_mapping import STUDENT_ASSESMENT_COLUMN_MAPPING
from config.config import DATA_ROOT_PATH
from config.logger_config import get_logger
from util.util import copy_data_to_db, get_ordered_db_table_columns,moved_files


logger = get_logger(name=__name__, log_file="load_student_asssessment_data.log")

def load_student_assessment_data():
    try:
        logger.info("Starting to load student assessment raw data")
        db_conn = db_connection_pool.getconn()
        file_path = f"{DATA_ROOT_PATH}/studentAssessment.csv"
        ordered_columns = get_ordered_db_table_columns(file_path=file_path, column_mapping=STUDENT_ASSESMENT_COLUMN_MAPPING)
        copy_data_to_db(db_connection=db_conn, file_path=file_path,table_name="student_assessments", columns=ordered_columns,logger=logger)
        db_conn.commit()
        moved_files(file_name="studentAssessment.csv", is_processed=True)
        logger.info("loading student assessment raw data done successfully")
    except Exception as e:
        db_conn.rollback()
        moved_files(file_name="studentAssessment.csv", is_processed=False)
        logger.exception("something went wrong. Failed to load student assessment raw data")
    finally:
        db_connection_pool.putconn()
