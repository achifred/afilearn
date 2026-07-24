from config.databse_config import db_connection_pool
from config.column_mapping import COURSES_COLUMN_MAPPING
from config.config import DATA_ROOT_PATH
from config.logger_config import get_logger
from util.util import copy_data_to_db, get_ordered_db_table_columns, moved_files

logger = get_logger(name=__name__, log_file="load_courses_data.log")

def load_courses_data():
    try:
        logger.info("Starting to load courses data")
        db_connection = db_connection_pool.getconn()
        file_path = f"{DATA_ROOT_PATH}/courses.csv"
        columns = get_ordered_db_table_columns(file_path=file_path, column_mapping=COURSES_COLUMN_MAPPING)
        copy_data_to_db(db_connection=db_connection,file_path=file_path, table_name="courses",columns=columns,logger=logger)
        db_connection.commit()
        moved_files(file_name="courses.csv", is_processed=True)
        logger.info("loading courses data done successfully")
    except Exception as e:
        db_connection.rollback()
        # moved_files(file_name="courses.csv", is_processed=False)
        logger.exception("something went wrong. Failed to load courses data")
    finally:
        db_connection_pool.putconn()


