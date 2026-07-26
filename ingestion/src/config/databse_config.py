from psycopg_pool import ConnectionPool
from src.config.env_vars import DB_HOST,DB_NAME, DB_PASSWORD,DB_PORT,DB_USER


DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
db_connection_pool = ConnectionPool(
    conninfo=DATABASE_URL,
    min_size=1,
    max_size=10,
)
  # Establish the connection pool
