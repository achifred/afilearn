import sys
import time
import logging
from tabulate import tabulate
from bigdata.src.config.spark_config import get_spark_session, ensure_raw_data, OUTPUT_MART_DIR
from bigdata.src.jobs.vle_activity_spikes import run_vle_activity_spikes
from bigdata.src.jobs.resource_pareto import run_resource_pareto
from bigdata.src.jobs.student_velocity import run_student_velocity

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)]
)

logger = logging.getLogger("bigdata.main")

def format_spark_table(df, limit=10, headers=None):
    """Helper to convert top N Spark DataFrame rows into a tabulate grid string."""
    rows = df.limit(limit).collect()
    if not rows:
        return "No data found."
    data = [[row[col] for col in df.columns] for row in rows]
    return tabulate(data, headers=headers or df.columns, tablefmt="grid")

def main():
    start_time = time.time()
    logger.info("Starting Phase 9 PySpark Big Data Processing Pipeline...")
    
    spark = None
    try:
        spark = get_spark_session()
        OUTPUT_MART_DIR.mkdir(parents=True, exist_ok=True)
        
        # Ensure input CSV files are extracted and available
        vle_csv_path = ensure_raw_data("studentVle.csv")
        site_csv_path = ensure_raw_data("vle.csv")
        
        logger.info("Loading DataFrames into Apache Spark engine...")
        vle_df = spark.read.option("header", "true").csv(vle_csv_path)
        site_df = spark.read.option("header", "true").csv(site_csv_path)
        
        logger.info(f"Loaded studentVle dataset. Triggering distributed execution...")
        
        # Job 1: Daily Activity Spikes
        spikes_df = run_vle_activity_spikes(vle_df, OUTPUT_MART_DIR)
        print("\n" + "="*80)
        print("JOB 1 RESULTS: TOP 10 PEAK DAILY STUDY SPIKES (BY TOTAL CLICKS)")
        print("="*80)
        print(format_spark_table(spikes_df, limit=10, headers=["Module", "Presentation", "Day Offset", "Total Clicks", "Active Students", "Avg Clicks/Student"]))
        
        # Job 2: Learning Resource Pareto Analysis
        pareto_df = run_resource_pareto(vle_df, site_df, OUTPUT_MART_DIR)
        print("\n" + "="*80)
        print("JOB 2 RESULTS: LEARNING RESOURCE PARETO DISTRIBUTION (80/20 RULE)")
        print("="*80)
        print(format_spark_table(pareto_df, limit=10, headers=["Activity Type", "Total Clicks", "Unique Sites", "Traffic Share (%)", "Cumulative (%)"]))
        
        # Job 3: Student Engagement Velocity & Drop-off Detection
        velocity_df = run_student_velocity(vle_df, OUTPUT_MART_DIR)
        print("\n" + "="*80)
        print("JOB 3 RESULTS: SEVERE STUDENT ENGAGEMENT DROP-OFF WARNINGS (>50% DECLINE)")
        print("="*80)
        warnings_df = velocity_df.filter(velocity_df["dropoff_warning"] == True)
        print(format_spark_table(warnings_df, limit=10, headers=["Student ID", "Module", "Presentation", "Week", "Weekly Clicks", "Prev Week", "Velocity Change (%)", "Warning Flag"]))
        
        elapsed = time.time() - start_time
        logger.info(f"Phase 9 PySpark Big Data processing completed successfully in {elapsed:.2f} seconds!")
        
    except Exception as e:
        logger.exception(f"PySpark pipeline execution failed: {e}")
        sys.exit(1)
    finally:
        if spark:
            logger.info("Shutting down SparkSession...")
            spark.stop()

if __name__ == "__main__":
    main()
