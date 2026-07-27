import logging
from pathlib import Path
from pyspark.sql import DataFrame
from pyspark.sql.window import Window
from pyspark.sql.functions import col, sum as _sum, floor, lag, round as _round, when

logger = logging.getLogger("bigdata.student_velocity")

def run_student_velocity(vle_df: DataFrame, output_dir: Path) -> DataFrame:
    """
    Job 3: Student Engagement Velocity & Behavioral Drop-off Detection.
    Partitions clickstream data into 7-day weekly intervals per student enrollment.
    Uses PySpark lag window functions to compute week-over-week click velocity changes,
    flagging severe drop-offs (> 50% decline) that often precede course withdrawal.
    """
    logger.info("Executing PySpark Job 3: Student Engagement Velocity & Drop-off Detection...")
    
    df = vle_df.withColumn("date_int", col("date").cast("integer")) \
               .withColumn("clicks_int", col("sum_click").cast("integer")) \
               .withColumn("week_number", floor(col("date_int") / 7))
               
    # Aggregate weekly clicks per student enrollment
    weekly_df = df.groupBy("id_student", "code_module", "code_presentation", "week_number") \
                  .agg(_sum("clicks_int").alias("weekly_clicks"))
                  
    # Define window for week-over-week velocity comparison
    window_spec = Window.partitionBy("id_student", "code_module", "code_presentation") \
                        .orderBy("week_number")
                        
    velocity_df = weekly_df.withColumn("prev_week_clicks", lag("weekly_clicks", 1).over(window_spec)) \
        .withColumn(
            "velocity_change_pct",
            when(col("prev_week_clicks") > 0, 
                 _round(((col("weekly_clicks") - col("prev_week_clicks")) / col("prev_week_clicks")) * 100, 2)
            ).otherwise(0.0)
        ) \
        .withColumn(
            "dropoff_warning",
            when((col("velocity_change_pct") <= -50.0) & (col("prev_week_clicks") >= 50), True).otherwise(False)
        ) \
        .orderBy("id_student", "week_number")
        
    # Write to Parquet Mart
    output_path = output_dir / "student_engagement_velocity.parquet"
    logger.info(f"Saving Job 3 results to Parquet: {output_path}")
    velocity_df.write.mode("overwrite").parquet(str(output_path))
    
    return velocity_df
