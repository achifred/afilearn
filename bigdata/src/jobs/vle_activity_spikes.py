import logging
from pathlib import Path
from pyspark.sql import DataFrame
from pyspark.sql.functions import col, sum as _sum, countDistinct, round as _round

logger = logging.getLogger("bigdata.vle_activity_spikes")

def run_vle_activity_spikes(vle_df: DataFrame, output_dir: Path) -> DataFrame:
    """
    Job 1: Computes daily activity engagement spikes across course presentations.
    Aggregates total clicks and distinct active students per day offset.
    Identifies peak study days that typically precede assessment deadlines.
    """
    logger.info("Executing PySpark Job 1: Daily VLE Activity Spikes...")
    
    # Ensure numerical casting for aggregation
    df = vle_df.withColumn("date_int", col("date").cast("integer")) \
               .withColumn("clicks_int", col("sum_click").cast("integer"))
               
    daily_spikes = df.groupBy("code_module", "code_presentation", "date_int") \
        .agg(
            _sum("clicks_int").alias("total_daily_clicks"),
            countDistinct("id_student").alias("active_students")
        ) \
        .withColumn("avg_clicks_per_student", _round(col("total_daily_clicks") / col("active_students"), 2)) \
        .orderBy(col("total_daily_clicks").desc())
        
    # Write to Parquet Mart
    output_path = output_dir / "daily_activity_spikes.parquet"
    logger.info(f"Saving Job 1 results to Parquet: {output_path}")
    daily_spikes.write.mode("overwrite").parquet(str(output_path))
    
    return daily_spikes
