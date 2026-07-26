from src.config.databse_config import db_connection_pool
from src.config.column_mapping import STUDENT_REGISTRATION_COLUMN_MAPPIING
from src.config.env_vars import DATA_ROOT_PATH
from src.config.logger_config import get_logger
from src.util.util import copy_data_to_db, get_ordered_db_table_columns, moved_files

logger = get_logger(name=__name__, log_file="load_student_reg_data.log")

def load_student_registration_data():
    try:
        logger.info("Starting to load student registration raw data")
        db_conn = db_connection_pool.getconn()
        
        file_path = f"{DATA_ROOT_PATH}/studentRegistration.csv"
        ordered_columns = get_ordered_db_table_columns(file_path=file_path, column_mapping=STUDENT_REGISTRATION_COLUMN_MAPPIING)
        
        copy_data_to_db(db_connection=db_conn, file_path=file_path,table_name="student_registrations",columns=ordered_columns,logger=logger)
        db_conn.commit()
        
        moved_files(file_name="studentRegistration.csv", is_processed=True)
        logger.info("loading student registration raw data done successfully")
   
    except Exception as e:
        
        db_conn.rollback()
        moved_files(file_name="studentRegistration.csv", is_processed=False)
        logger.exception("something went wrong. Failed to load student raw data")

    finally:
        
        db_connection_pool.putconn(db_conn)

