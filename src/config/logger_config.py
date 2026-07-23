import logging
from logging.handlers import RotatingFileHandler
from pathlib import Path
from config.config import MAX_LOG_FILE_SIZE


LOG_DIR = Path("logs")
LOG_DIR.mkdir(exist_ok=True)


def get_logger(name:str, log_file:str, log_level=logging.INFO):

    logger = logging.getLogger(name)

    # to prevent duplicate handlers
    if logger.handlers:
        return logger
    
    logger.setLevel(log_level)
    formatter = logging.Formatter(
        fmt= "%(acstime)s | %(levelname)s | %(name)s | %(message)s",
        datefmt= "%Y-%m-%d %H:%M:$S"
    )


    log_file_path = LOG_DIR/log_file
    
    console_handler = logging.StreamHandler()
    file_handler = RotatingFileHandler(
        filename=log_file_path,
        maxBytes=MAX_LOG_FILE_SIZE,
        backupCount=100,
        mode="a"

    )

    console_handler.setFormatter(fmt=formatter)
    file_handler.setFormatter(fmt=formatter)
    logger.addHandler(console_handler)
    logger.addHandler(file_handler)
    logger.propagate = False

    return logger
    