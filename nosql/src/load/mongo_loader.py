import logging
from typing import List, Dict, Any
from pymongo import ReplaceOne, IndexModel, ASCENDING, DESCENDING
from nosql.src.config.mongo_config import get_mongo_collection

logger = logging.getLogger("nosql.mongo_loader")

def load_profiles_to_mongodb(profiles: List[Dict[str, Any]], batch_size: int = 1000) -> int:
    """
    Upserts Student Learning Profile documents into MongoDB and ensures
    appropriate indexes exist for fast analytical queries.
    """
    if not profiles:
        logger.warning("No profiles provided to load into MongoDB.")
        return 0
        
    collection = get_mongo_collection()
    
    # Create indexes for learning analytics workloads
    logger.info("Creating MongoDB indexes...")
    indexes = [
        IndexModel([("student_id", ASCENDING)], name="idx_student_id"),
        IndexModel([("course_enrollment.module_code", ASCENDING), ("course_enrollment.presentation_code", ASCENDING)], name="idx_course"),
        IndexModel([("course_enrollment.final_result", ASCENDING)], name="idx_outcome"),
        IndexModel([("assessment_metrics.average_score", DESCENDING)], name="idx_avg_score"),
        IndexModel([("engagement_metrics.total_vle_clicks", DESCENDING)], name="idx_clicks")
    ]
    collection.create_indexes(indexes)
    logger.info("Indexes verified and created successfully.")
    
    total_upserted = 0
    total_modified = 0
    
    logger.info(f"Starting MongoDB batch upsert for {len(profiles)} documents in chunks of {batch_size}...")
    for i in range(0, len(profiles), batch_size):
        batch = profiles[i:i + batch_size]
        requests = [
            ReplaceOne({"_id": doc["_id"]}, doc, upsert=True)
            for doc in batch
        ]
        result = collection.bulk_write(requests, ordered=False)
        total_upserted += result.upserted_count
        total_modified += result.modified_count
        logger.info(f"Processed batch {i // batch_size + 1}/{((len(profiles) - 1) // batch_size) + 1}...")
        
    logger.info(f"MongoDB loading completed. Upserted: {total_upserted}, Modified: {total_modified}, Total Active Docs: {collection.count_documents({})}")
    return len(profiles)
