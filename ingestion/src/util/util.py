import datetime
import psycopg
import pandas as pd
import shutil
from psycopg import sql
from typing import Optional
from logging import Logger
from pathlib import Path
from config.config import FAILED_DATA_PATH, PROCESSED_DATA_PATH, DATA_ROOT_PATH



def copy_data_to_db(
        db_connection: psycopg,
        file_path:str,
        table_name: str,
        columns: list[str],
        logger: Optional[Logger] = None
)-> None:
    
    """
    Copy data from a StringIO buffer to a PostgreSQL table using the COPY command.

    Args:
        connection (psycopg.Connection): The database connection.
        buffer (StringIO): The StringIO buffer containing the data to be copied.
        table_name (str): The name of the target table in the database.
        columns (list[str]): A list of column names corresponding to the data in the buffer.

    Returns:
        None
    """

    copy_sql = sql.SQL("COPY {table} ({cols}) FROM STDIN WITH (FORMAT CSV, HEADER TRUE)").format(
        table =sql.Identifier(table_name),
        cols = sql.SQL(", ").join(sql.Identifier(c) for c in columns)
    )
    try:
        logger.info(f"beginning to copy raw data into {table_name} table")
        with db_connection.cursor() as cur:
            with open(file_path) as f, cur.copy(copy_sql) as copy:
                while data := f.read(1024 * 1024):
                    copy.write(data)
                    logger.info(f"copied {1024 *1024} raw data into {table_name} table")
        logger.info(f"successfully copied raw data into {table_name} table")
    except Exception as e:
        logger.exception("something went wrong. Failed to copy data to database")
        raise e
    


def get_ordered_db_table_columns(file_path:str, column_mapping: dict[str, str]) -> list[str]:

    csv_header = pd.read_csv(file_path, nrows=0).columns.tolist()

    missing_columns = [c for c in csv_header if c not in column_mapping]
    if missing_columns:
        raise ValueError(f"no mapping defined for csv columns: {missing_columns}")
    
    return [column_mapping[c] for c in csv_header]


def moved_files(file_name: str,  is_processed: bool) -> Path:

    source_dir = Path(DATA_ROOT_PATH)

    destination_dir = Path(PROCESSED_DATA_PATH) if is_processed else Path(FAILED_DATA_PATH)

    destination_dir.mkdir(parents=True, exist_ok=True)
    source = source_dir/file_name

    timestamp = datetime.utcnow().strftime("%Y%m%dT%H%M%SZ")
    new_name = f"{timestamp}_{file_name}"
    
    target = destination_dir/new_name
    
    shutil.move(source, target)

    return target
