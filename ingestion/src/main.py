from src.pipeline.pipeline import run_pipeline, run_schema, run_pipelines
from src.config.databse_config import db_connection_pool

def main() -> None:
    with db_connection_pool:
        run_schema()
        run_pipelines()


if __name__ == "__main__":
    main()
