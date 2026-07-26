from src.config.databse_config import db_connection_pool
from src.config.column_mapping import VLE_COLUMN_MAPPING
from src.config.env_vars import DATA_ROOT_PATH
from src.config.logger_config import get_logger
from src.util.util import copy_data_to_db, get_ordered_db_table_columns,moved_files


logger = get_logger(name=__name__, log_file="load_vle_data.log")

def load_vle_data():
    try:
        logger.info("Starting to load vle raw data")
        db_connection = db_connection_pool.getconn()
        
        file_path = f"{DATA_ROOT_PATH}/vle.csv"
        columns = get_ordered_db_table_columns(file_path=file_path, column_mapping=VLE_COLUMN_MAPPING)
        
        copy_data_to_db(db_connection=db_connection, file_path=file_path,table_name="vles", columns=columns,logger=logger )
        db_connection.commit()
        
        moved_files(file_name="vle.csv", is_processed=True)
        logger.info("loading vle raw data done successfully")
    
    except Exception:
        
        db_connection.rollback()
        moved_files(file_name="vle.csv", is_processed=False)
        logger.exception("something went wrong. Failed to load vle raw data")
    
    finally:
        db_connection_pool.putconn(db_connection)
