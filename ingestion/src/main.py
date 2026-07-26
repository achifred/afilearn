from src.pipeline.pipeline import  run_schema, run_pipeline
from src.config.databse_config import db_connection_pool

def main() -> None:
    with db_connection_pool:
        run_schema()
        run_pipeline()


if __name__ == "__main__":
    main()
