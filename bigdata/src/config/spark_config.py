import os
import zipfile
import logging
from pathlib import Path
from pyspark.sql import SparkSession

logger = logging.getLogger("bigdata.spark_config")

PROJECT_ROOT = Path(__file__).resolve().parents[3]
RAW_DATA_DIR = PROJECT_ROOT / "data" / "raw"
DATASET_ZIP = PROJECT_ROOT / "data" / "dataset.zip"
OUTPUT_MART_DIR = PROJECT_ROOT / "data" / "processed" / "bigdata_marts"

def get_spark_session(app_name: str = "AfiLearn_BigData_PySpark") -> SparkSession:
    """
    Initializes and returns an Apache SparkSession configured for local multi-core execution.
    Includes Java 17+ / Java 26+ JVM module opening flags to prevent ClassNotFoundException / Cleaner access errors.
    """
    logger.info(f"Initializing SparkSession: {app_name} in local[*] mode...")
    
    # Ensure Apache Spark runs on a supported LTS Java runtime (8, 11, 17, or 21) instead of Java 24/26
    current_java = os.environ.get("JAVA_HOME", "")
    if not current_java or any(ver in current_java for ver in ["jdk-24", "jdk-25", "jdk-26", "24.", "25.", "26."]):
        possible_homes = [
            "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home",
            "/opt/homebrew/Cellar/openjdk@21/21.0.7/libexec/openjdk.jdk/Contents/Home",
            "/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home",
            "/opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk/Contents/Home",
            "/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home",
            "/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home"
        ]
        for home in possible_homes:
            if os.path.exists(home):
                logger.info(f"Selecting compatible LTS Java runtime for PySpark: {home}")
                os.environ["JAVA_HOME"] = home
                os.environ["PATH"] = f"{home}/bin:{os.environ.get('PATH', '')}"
                break
                
    # Required JVM flags for Java 17+ and Java 26+ compatibility with Apache Spark Unsafe / MemoryManager
    java_opts = (
        "--add-opens=java.base/java.lang=ALL-UNNAMED "
        "--add-opens=java.base/java.lang.invoke=ALL-UNNAMED "
        "--add-opens=java.base/java.lang.reflect=ALL-UNNAMED "
        "--add-opens=java.base/java.io=ALL-UNNAMED "
        "--add-opens=java.base/java.net=ALL-UNNAMED "
        "--add-opens=java.base/java.nio=ALL-UNNAMED "
        "--add-opens=java.base/java.util=ALL-UNNAMED "
        "--add-opens=java.base/java.util.concurrent=ALL-UNNAMED "
        "--add-opens=java.base/java.util.concurrent.atomic=ALL-UNNAMED "
        "--add-opens=java.base/jdk.internal.ref=ALL-UNNAMED "
        "--add-opens=java.base/sun.nio.ch=ALL-UNNAMED "
        "--add-opens=java.base/sun.nio.cs=ALL-UNNAMED "
        "--add-opens=java.base/sun.security.action=ALL-UNNAMED "
        "--add-opens=java.base/sun.util.calendar=ALL-UNNAMED "
        "--add-opens=java.security.jgss/sun.security.krb5=ALL-UNNAMED"
    )
    if "PYSPARK_SUBMIT_ARGS" not in os.environ:
        os.environ["PYSPARK_SUBMIT_ARGS"] = f'--driver-java-options "{java_opts}" pyspark-shell'
        
    spark = SparkSession.builder \
        .appName(app_name) \
        .master("local[*]") \
        .config("spark.driver.extraJavaOptions", java_opts) \
        .config("spark.executor.extraJavaOptions", java_opts) \
        .config("spark.driver.memory", "2g") \
        .config("spark.sql.shuffle.partitions", "8") \
        .config("spark.sql.execution.arrow.pyspark.enabled", "true") \
        .getOrCreate()
        
    # Reduce verbose Spark/Hadoop log output
    spark.sparkContext.setLogLevel("WARN")
    return spark

def ensure_raw_data(file_name: str) -> str:
    """
    Ensures that the requested CSV file is present in data/raw/.
    If missing, automatically extracts it from data/dataset.zip.
    Returns the absolute file path string.
    """
    target_path = RAW_DATA_DIR / file_name
    if target_path.exists():
        logger.info(f"Verified raw dataset exists at: {target_path}")
        return str(target_path)
        
    if DATASET_ZIP.exists():
        logger.info(f"'{file_name}' not found in raw dir. Extracting from {DATASET_ZIP}...")
        RAW_DATA_DIR.mkdir(parents=True, exist_ok=True)
        with zipfile.ZipFile(DATASET_ZIP, "r") as zip_ref:
            zip_ref.extract(file_name, RAW_DATA_DIR)
        logger.info(f"Successfully extracted {file_name} to {target_path}")
        return str(target_path)
    else:
        raise FileNotFoundError(f"Neither {target_path} nor {DATASET_ZIP} could be found!")
