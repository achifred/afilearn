import os
from src.config.databse_config import db_connection_pool
from src.config.column_mapping import ASSESSMENT_COLUMN_MAPPING
from src.config.env_vars import DATA_ROOT_PATH
from src.config.logger_config import get_logger
from src.util.util import copy_data_to_db, get_ordered_db_table_columns, moved_files



def load_raw_data(file_name:str, column_mapping:dict[str,str],table_name:str,log_file:str):
    
    try:
        logger = get_logger(name= log_file, log_file=f"{log_file}.log")

        logger.info(f"Starting to load {file_name} data")

        db_connection = db_connection_pool.getconn()

        file_path = f"{DATA_ROOT_PATH}/{file_name}"

        if os.path.isfile(file_path) and os.path.getsize(file_path) > 0:

            columns = get_ordered_db_table_columns(file_path=file_path, column_mapping=column_mapping)

            copy_data_to_db(db_connection=db_connection, file_path=file_path,table_name=table_name, columns=columns, logger=logger )
            db_connection.commit()

            moved_files(file_name=file_name, is_processed=True)
            logger.info(f"loading {file_name} data done successfully")

    except Exception:

        db_connection.rollback()
        moved_files(file_name=file_name, is_processed=False)
        logger.exception(f"something went wrong, failed to load {file_name} data")

    finally:

        db_connection_pool.putconn(db_connection)
