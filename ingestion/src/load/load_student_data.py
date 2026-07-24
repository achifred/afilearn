from config.databse_config import db_connection_pool
from config.column_mapping import STUDENT_COLUMN_MAPPING
from config.config import DATA_ROOT_PATH
from config.logger_config import get_logger
from util.util import copy_data_to_db, get_ordered_db_table_columns,moved_files

logger = get_logger(name=__name__, log_file="load_student_data.log")

def load_student_data():
    try:
        logger.info("Starting to load student raw data")
        db_connection = db_connection_pool.getconn()
        file_path = f"{DATA_ROOT_PATH}/studentInfo.csv"
        columns = get_ordered_db_table_columns(file_path=file_path, column_mapping=STUDENT_COLUMN_MAPPING)
        copy_data_to_db(db_connection=db_connection, file_path=file_path, table_name="stundent_info", columns=columns,logger=logger)
        db_connection.commit()
        moved_files(file_name="studentInfo.csv", is_processed=True)
        logger.info("loading student raw data done successfully")
    except Exception:
        db_connection.rollback()
        logger.exception("something went wrong. Failed to load student raw data")
    finally:
        db_connection_pool.putconn()

       

