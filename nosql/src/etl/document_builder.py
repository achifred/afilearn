import logging
from typing import List, Dict, Any
from nosql.src.config.pg_config import get_pg_connection

logger = logging.getLogger("nosql.document_builder")

def build_student_profiles(limit: int = 0) -> List[Dict[str, Any]]:
    """
    Extracts relational student performance and demographic data from PostgreSQL
    and constructs denormalized hierarchical JSON documents for MongoDB.
    """
    query = """
    SELECT 
        msp.student_performance_id,
        ds.student_number AS student_id,
        ds.region,
        ds.highest_education,
        ds.idm_band,
        ds.age_band,
        ds.studied_credits,
        ds.is_disabled,
        dm.module_code,
        dmp.presentation_code,
        dmp.module_presentation_length,
        msp.total_assessment,
        msp.assessments_submitted,
        msp.average_assessment_score,
        msp.lowest_assessment_score,
        msp.highest_assessment_score,
        msp.total_vle_clicks,
        msp.final_result,
        msp.is_passed
    FROM mart.mart_student_performance msp
    JOIN warehouse.dim_students ds ON msp.student_id = ds.student_id
    JOIN warehouse.dim_module_presentations dmp ON msp.presentation_id = dmp.presentation_id
    JOIN warehouse.dim_modules dm ON dmp.module_id = dm.module_id
    """
    if limit > 0:
        query += f" LIMIT {limit}"
        
    profiles = []
    try:
        with get_pg_connection() as conn:
            with conn.cursor() as cur:
                logger.info("Executing relational data extraction query from PostgreSQL...")
                cur.execute(query)
                rows = cur.fetchall()
                logger.info(f"Extracted {len(rows)} records from warehouse/mart tables.")
                
                for row in rows:
                    doc = {
                        "_id": f"{row['student_id']}_{row['module_code']}_{row['presentation_code']}",
                        "student_id": str(row["student_id"]),
                        "demographics": {
                            "region": row["region"],
                            "highest_education": row["highest_education"],
                            "imd_band": row["idm_band"],
                            "age_band": row["age_band"],
                            "studied_credits": int(row["studied_credits"] or 0),
                            "is_disabled": bool(row["is_disabled"]) if row["is_disabled"] is not None else False
                        },
                        "course_enrollment": {
                            "module_code": row["module_code"],
                            "presentation_code": row["presentation_code"],
                            "presentation_length_days": int(row["module_presentation_length"] or 0),
                            "final_result": row["final_result"],
                            "is_passed": bool(row["is_passed"]) if row["is_passed"] is not None else False
                        },
                        "assessment_metrics": {
                            "total_available": int(row["total_assessment"] or 0),
                            "submitted_count": int(row["assessments_submitted"] or 0),
                            "average_score": float(row["average_assessment_score"] or 0.0),
                            "lowest_score": int(row["lowest_assessment_score"] or 0),
                            "highest_score": int(row["highest_assessment_score"] or 0)
                        },
                        "engagement_metrics": {
                            "total_vle_clicks": int(row["total_vle_clicks"] or 0)
                        }
                    }
                    profiles.append(doc)
    except Exception as e:
        logger.exception("Failed to build student profile documents from PostgreSQL.")
        raise e
        
    return profiles
