# import pandas as pd


# def extract_data(
#         file_path: str,
#         batch_size: int
# ):

#     for chunck in pd.read_csv(file_path, chunksize=batch_size):
#         chunck.
    



import psycopg
from io import StringIO
import pandas as pd


def copy_csv_to_postgres(
    connection: psycopg.Connection,
    csv_path: str,
    table_name: str,
    columns: list[str],
    batch_size: int = 10000,
) -> None:
    """
    Load a CSV file into PostgreSQL using COPY in batches.

    Args:
        connection: psycopg connection.
        csv_path: Path to the CSV file.
        table_name: Target PostgreSQL table.
        columns: List of target table columns in CSV order.
        batch_size: Number of rows per batch.
    """

    copy_sql = f"""
        COPY {table_name}
        ({", ".join(columns)})
        FROM STDIN
        WITH (
            FORMAT CSV,
            HEADER FALSE
        )
    """

    total_rows = 0

    for chunk in pd.read_csv(csv_path, chunksize=batch_size):

        # Convert the DataFrame chunk into an in-memory CSV
        buffer = StringIO()
        chunk.to_csv(
            buffer,
            index=False,
            header=False,
            na_rep=""
        )
        buffer.seek(0)

        with connection.cursor() as cur:
            with cur.copy(copy_sql) as copy:
                copy.write(buffer.read())

        connection.commit()

        total_rows += len(chunk)
        print(f"Loaded {total_rows:,} rows...")


    print(f"\nFinished loading {total_rows:,} rows into {table_name}.")
