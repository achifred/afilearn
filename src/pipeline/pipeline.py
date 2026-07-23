from config.config import LOAD_PIPELINE
from config.logger_config import get_logger

logger = get_logger(name=__name__,log_file="pipeline.log")

def run_pipeline():
    logger.info("Starting load data pipeline")
    for item in LOAD_PIPELINE:
        logger.info(f"loadding {item["name"]} data.....")
        item["function"]()
        logger.info(f"loading {item['name']} data done.")

    logger.info("load data pipeline done successfully" )