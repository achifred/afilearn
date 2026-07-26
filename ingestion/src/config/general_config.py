from src.config.column_mapping import ASSESSMENT_COLUMN_MAPPING,STUDENT_REGISTRATION_COLUMN_MAPPIING,COURSES_COLUMN_MAPPING,VLE_COLUMN_MAPPING,STUDENT_COLUMN_MAPPING,STUDENT_VLE_COLUMN_MAPPING,STUDENT_ASSESMENT_COLUMN_MAPPING


LOAD_PIPELINES = [
    {
        "name": "student info",
        "file_name": "studentInfo.csv",
        "column_mapping": STUDENT_COLUMN_MAPPING,
        "table_name": "student_info",
        "log_file_name": "load_student_data"
    },
    {
        "name": "courses",
        "file_name": "courses.csv",
        "column_mapping": COURSES_COLUMN_MAPPING,
        "table_name": "courses",
        "log_file_name": "load_courses_data"
    },
    {
        "name": "assessments",
        "file_name": "assessments.csv",
        "column_mapping": ASSESSMENT_COLUMN_MAPPING,
        "table_name": "assessments",
        "log_file_name": "load_assessments_data"
    },
     {
        "name": "student assessments",
        "file_name": "studentAssessment.csv",
        "column_mapping": STUDENT_ASSESMENT_COLUMN_MAPPING,
        "table_name": "student_assessments",
        "log_file_name": "load_student_assessment_data"
    },
    {
        "name": "student registrations",
        "file_name": "studentRegistration.csv",
        "column_mapping": STUDENT_REGISTRATION_COLUMN_MAPPIING,
        "table_name": "student_registrations",
        "log_file_name": "load_registration_data"
    },
    {
        "name": "student vle",
        "file_name": "studentVle.csv",
        "column_mapping": STUDENT_VLE_COLUMN_MAPPING,
        "table_name": "student_vles",
        "log_file_name": "load_student_vle_data"
    },
    {
        "name": "vle",
        "file_name": "vle.csv",
        "column_mapping": VLE_COLUMN_MAPPING,
        "table_name": "vles",
        "log_file_name": "load_vle_data"
    }
]