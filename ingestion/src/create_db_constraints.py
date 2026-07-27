from src.config.databse_config import db_connection_pool
from src.util.util import get_path
from src.config.logger_config import get_logger

logger = get_logger(name=__name__,log_file="pipeline.log")

sql_path = get_path("sql/create_indexes.sql")
constraints_sql_path = get_path("sql/create_constraints.sql") 
sql_files = [sql_path, constraints_sql_path]

def run_constraints():
   try:
        with db_connection_pool:
            con = db_connection_pool.getconn()
            for sql in sql_files:
                with con.cursor() as cur:
                    with open(sql,'r') as f:
                        sql_queries = f.read()
                        cur.execute(sql_queries)

            con.commit()
            logger.info("constraints created successfully")
    
   except Exception:
       
       con.rollback()
       logger.exception("creating constraints failed")
   finally:
       db_connection_pool.putconn(con)


run_constraints()