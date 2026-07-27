from src.config.databse_config import db_connection_pool
from src.util.util import get_path
from src.config.logger_config import get_logger

logger = get_logger(name=__name__,log_file="pipeline.log")

sql_path = get_path("sql/create_indexes.sql")
constraints_sql_path = get_path("sql/create_constraints.sql") 

def create_indexes():
   try:
        with db_connection_pool:
            con = db_connection_pool.getconn()

            with con.cursor() as cur:
                with open(sql_path,'r') as f:
                    sql_queries = f.read()
                    cur.execute(sql_queries)

            con.commit()
            print("working")
            logger.info("indexes created successfully")
    
   except Exception:
       
       con.rollback()
       logger.exception("creating indexes failed")
   finally:
       db_connection_pool.putconn(con)


def create_constraints():
   try:

    with db_connection_pool:
        conn = db_connection_pool.getconn()

        with conn.cursor() as cur:
            with open(constraints_sql_path,'r') as f:
                sql_queries = f.read()
                cur.execute(sql_queries)

        conn.commit()
        print("working")
        logger.info("constraints created successfully")
    
   except Exception:
       conn.rollback()
       logger.exception("creating constriants failed")
   finally:
       db_connection_pool.putconn(conn)


# create_indexes()
create_constraints()