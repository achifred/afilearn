import sys
import logging
from nosql.src.etl.document_builder import build_student_profiles
from nosql.src.load.mongo_loader import load_profiles_to_mongodb
from nosql.src.analytics.queries import run_all_demo_queries

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)]
)

logger = logging.getLogger("nosql.main")

def main():
    logger.info("Starting NoSQL (MongoDB) Learning Profile Pipeline...")
    
    try:
        # 1. Extract and build JSON profiles from PostgreSQL
        logger.info("Phase 1: Extracting relational data and building JSON documents...")
        profiles = build_student_profiles()
        logger.info(f"Successfully constructed {len(profiles)} Student Learning Profile documents.")
        
        # 2. Load into MongoDB
        logger.info("Phase 2: Upserting documents into MongoDB and indexing...")
        loaded_count = load_profiles_to_mongodb(profiles)
        logger.info(f"Successfully loaded {loaded_count} documents into MongoDB.")
        
        # 3. Run Demo Analytics Queries
        logger.info("Phase 3: Executing NoSQL learning analytics demonstration queries...")
        run_all_demo_queries()
        
        logger.info("NoSQL pipeline completed successfully!")
    except Exception as e:
        logger.exception(f"NoSQL pipeline execution failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
