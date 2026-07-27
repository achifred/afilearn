BEGIN;

----------------------------------------------------
-- DIMENSION TABLES
----------------------------------------------------

-- dim_students
CREATE INDEX IF NOT EXISTS idx_dim_students_student_number
ON warehouse.dim_students (student_number);

CREATE INDEX IF NOT EXISTS idx_dim_students_region
ON warehouse.dim_students (region);

CREATE INDEX IF NOT EXISTS idx_dim_students_age_band
ON warehouse.dim_students (age_band);

CREATE INDEX IF NOT EXISTS idx_dim_students_highest_education
ON warehouse.dim_students (highest_education);


-- dim_presentations
CREATE INDEX IF NOT EXISTS idx_dim_presentations_module_id
ON warehouse.dim_module_presentations (module_id);

CREATE INDEX IF NOT EXISTS idx_dim_presentations_presentation_code
ON warehouse.dim_module_presentations (presentation_code);

CREATE INDEX IF NOT EXISTS idx_dim_presentations_module_presentation
ON warehouse.dim_module_presentations (
    module_id,
    presentation_code
);


-- dim_assessments
CREATE INDEX IF NOT EXISTS idx_dim_assessments_presentation
ON warehouse.dim_assessments (presentation_id);

CREATE INDEX IF NOT EXISTS idx_dim_assessments_type
ON warehouse.dim_assessments (assessment_type);


-- dim_vles
CREATE INDEX IF NOT EXISTS idx_dim_vles_presentation
ON warehouse.dim_vles (presentation_id);

CREATE INDEX IF NOT EXISTS idx_dim_vles_activity
ON warehouse.dim_vles (vle_activity_type_id);


----------------------------------------------------
-- FACT TABLES
----------------------------------------------------

-- fact_student_registrations
CREATE INDEX IF NOT EXISTS idx_fact_reg_student_presentation
ON warehouse.fact_student_registrations (
    student_id,
    presentation_id
);

CREATE INDEX IF NOT EXISTS idx_fact_reg_final_result
ON warehouse.fact_student_registrations (
    final_result
);


-- fact_student_assessments
CREATE INDEX IF NOT EXISTS idx_fact_assessment_student_assessment
ON warehouse.fact_student_assessments (
    student_id,
    assessment_id
);


-- fact_student_vles
CREATE INDEX IF NOT EXISTS idx_fact_vles_student_vle
ON warehouse.fact_student_vles (
    student_id,
    vle_id
);


----------------------------------------------------
-- MARTS
----------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_mart_student_performance_lookup
ON mart.mart_student_performance (
    student_id,
    module_id,
    presentation_id
);

COMMIT;