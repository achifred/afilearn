from src.config.pipeline_config import LOAD_PIPELINES
from src.config.logger_config import get_logger
from src.config.databse_config import db_connection_pool
from src.util.util import get_path
from src.load.loader import load_raw_data

logger = get_logger(name=__name__,log_file="pipeline.log")

sql_apth = get_path("sql/create_loading_tables.sql")

def run_schema():
   try:
        con = db_connection_pool.getconn()

        with con.cursor() as cur:
            with open(sql_apth,'r') as f:
                sql_queries = f.read()
                cur.execute(sql_queries)

        con.commit()
        logger.info("tables created successfully")
    
   except Exception:
       
       con.rollback()
       logger.exception("creating tables for raw schema failed")
   finally:
       db_connection_pool.putconn(con)
       

def run_pipeline():
    logger.info("Starting load data pipeline")
    for item in LOAD_PIPELINES:
        
        logger.info(f"loadding {item["file_name"]} data.....")

        file_name = item["file_name"]
        column_mapping =item["column_mapping"]
        table_name = item["table_name"]
        log_file_name = item["log_file_name"]

        load_raw_data(file_name=file_name, column_mapping=column_mapping, table_name=table_name, log_file=log_file_name)
        logger.info(f"loading {item['file_name']} data done.")

    logger.info("load data pipeline done successfully" )