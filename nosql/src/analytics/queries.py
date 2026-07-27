import logging
from typing import List, Dict, Any
from tabulate import tabulate
from nosql.src.config.mongo_config import get_mongo_collection

logger = logging.getLogger("nosql.analytics")

def query_at_risk_students(module_code: str = "AAA", limit: int = 5) -> List[Dict[str, Any]]:
    """
    Finds currently active students in a module who are at risk due to
    low assessment scores (< 50) or low VLE engagement (< 100 clicks).
    Demonstrates MongoDB nested document field querying and $or operator.
    """
    collection = get_mongo_collection()
    query = {
        "course_enrollment.module_code": module_code,
        "$or": [
            {"assessment_metrics.average_score": {"$lt": 50, "$gt": 0}},
            {"engagement_metrics.total_vle_clicks": {"$lt": 100}}
        ],
        "course_enrollment.final_result": {"$ne": "Withdrawn"}
    }
    
    results = list(collection.find(query, {"_id": 0, "student_id": 1, "course_enrollment": 1, "assessment_metrics": 1, "engagement_metrics": 1}).limit(limit))
    return results

def aggregate_engagement_by_outcome() -> List[Dict[str, Any]]:
    """
    Uses MongoDB Aggregation Pipeline to calculate average VLE clicks
    and average assessment scores grouped by final course result.
    Demonstrates $group, $avg, and $sort aggregation operators.
    """
    collection = get_mongo_collection()
    pipeline = [
        {
            "$group": {
                "_id": "$course_enrollment.final_result",
                "student_count": {"$sum": 1},
                "avg_vle_clicks": {"$avg": "$engagement_metrics.total_vle_clicks"},
                "avg_assessment_score": {"$avg": "$assessment_metrics.average_score"}
            }
        },
        {"$sort": {"avg_assessment_score": -1}}
    ]
    
    results = list(collection.aggregate(pipeline))
    return results

def query_high_performers(limit: int = 5) -> List[Dict[str, Any]]:
    """
    Finds top performing students who achieved a Distinction and submitted
    at least 4 assessments. Demonstrates multi-field indexing usage.
    """
    collection = get_mongo_collection()
    query = {
        "course_enrollment.final_result": "Distinction",
        "assessment_metrics.submitted_count": {"$gte": 4}
    }
    
    results = list(collection.find(query, {"_id": 0, "student_id": 1, "course_enrollment.module_code": 1, "assessment_metrics": 1, "engagement_metrics": 1}).sort("assessment_metrics.average_score", -1).limit(limit))
    return results

def run_all_demo_queries():
    """Executes and formats all NoSQL demonstration queries."""
    print("\n" + "=" * 80)
    print("MONGODB NOSQL LEARNING ANALYTICS DEMONSTRATION")
    print("=" * 80)
    
    # 1. At-Risk Students
    print("\n1. Querying At-Risk Students (Module AAA, Score < 50 or Clicks < 100):")
    at_risk = query_at_risk_students("AAA", limit=5)
    if at_risk:
        rows = [
            [
                r["student_id"],
                r["course_enrollment"]["module_code"],
                r["course_enrollment"]["presentation_code"],
                f"{r['assessment_metrics']['average_score']:.1f}",
                r["engagement_metrics"]["total_vle_clicks"],
                r["course_enrollment"]["final_result"]
            ]
            for r in at_risk
        ]
        print(tabulate(rows, headers=["Student ID", "Module", "Presentation", "Avg Score", "VLE Clicks", "Current Result"], tablefmt="grid"))
    else:
        print("No at-risk students found matching criteria (or database empty).")
        
    # 2. Aggregation by Outcome
    print("\n2. Aggregation Pipeline: Engagement & Score Metrics by Final Outcome:")
    agg = aggregate_engagement_by_outcome()
    if agg:
        rows = [
            [
                r["_id"] or "Unknown",
                r["student_count"],
                f"{r['avg_vle_clicks']:.1f}",
                f"{r['avg_assessment_score']:.1f}"
            ]
            for r in agg
        ]
        print(tabulate(rows, headers=["Final Result", "Student Count", "Avg VLE Clicks", "Avg Assessment Score"], tablefmt="grid"))
    else:
        print("No aggregation results found.")
        
    # 3. High Performers
    print("\n3. High Performers (Distinction with >= 4 Assessments Submitted):")
    high_perf = query_high_performers(limit=5)
    if high_perf:
        rows = [
            [
                r["student_id"],
                r["course_enrollment"]["module_code"],
                r["assessment_metrics"]["submitted_count"],
                f"{r['assessment_metrics']['average_score']:.1f}",
                r["engagement_metrics"]["total_vle_clicks"]
            ]
            for r in high_perf
        ]
        print(tabulate(rows, headers=["Student ID", "Module", "Submitted", "Avg Score", "VLE Clicks"], tablefmt="grid"))
    else:
        print("No high performers found.")
    print("\n" + "=" * 80 + "\n")
