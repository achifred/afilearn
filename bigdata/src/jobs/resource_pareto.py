import logging
from pathlib import Path
from pyspark.sql import DataFrame
from pyspark.sql.window import Window
from pyspark.sql.functions import col, sum as _sum, countDistinct, round as _round

logger = logging.getLogger("bigdata.resource_pareto")

def run_resource_pareto(vle_df: DataFrame, site_df: DataFrame, output_dir: Path) -> DataFrame:
    """
    Job 2: Learning Resource Pareto Analysis (80/20 Rule).
    Joins studentVle interactions with VLE site metadata to aggregate traffic by activity_type.
    Calculates percentage contribution and cumulative distribution using PySpark Window functions.
    """
    logger.info("Executing PySpark Job 2: Learning Resource Pareto Analysis...")
    
    # Cast joining keys and numeric values
    vle_clean = vle_df.withColumn("id_site_int", col("id_site").cast("integer")) \
                      .withColumn("clicks_int", col("sum_click").cast("integer"))
    site_clean = site_df.withColumn("id_site_int", col("id_site").cast("integer"))
    
    # Join clickstream with VLE metadata
    joined = vle_clean.join(site_clean, on="id_site_int", how="inner")
    
    # Group by activity_type
    grouped = joined.groupBy("activity_type") \
        .agg(
            _sum("clicks_int").alias("total_clicks"),
            countDistinct("id_site_int").alias("unique_resources")
        )
        
    # Compute total across all types for percentage calculation
    total_row = grouped.agg(_sum("total_clicks").alias("all_clicks")).collect()
    total_all_clicks = total_row[0]["all_clicks"] if total_row and total_row[0]["all_clicks"] else 1
    
    window_spec = Window.orderBy(col("total_clicks").desc())
    
    pareto_df = grouped.withColumn("traffic_share_pct", _round((col("total_clicks") / total_all_clicks) * 100, 2)) \
                       .withColumn("cumulative_pct", _round(_sum("traffic_share_pct").over(window_spec), 2)) \
                       .orderBy(col("total_clicks").desc())
                       
    # Write to Parquet Mart
    output_path = output_dir / "resource_pareto.parquet"
    logger.info(f"Saving Job 2 results to Parquet: {output_path}")
    pareto_df.write.mode("overwrite").parquet(str(output_path))
    
    return pareto_df
