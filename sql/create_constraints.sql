BEGIN;

----------------------------------------------------
-- DIMENSION TABLES
----------------------------------------------------

-- dim_module_presentations → dim_modules
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_dim_module_presentations_module'
    ) THEN
        ALTER TABLE warehouse.dim_module_presentations
        ADD CONSTRAINT fk_dim_module_presentations_module
        FOREIGN KEY (module_id)
        REFERENCES warehouse.dim_modules(module_id);
    END IF;
END $$;

----------------------------------------------------
-- dim_assessments
----------------------------------------------------

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_dim_assessments_presentation'
    ) THEN
        ALTER TABLE warehouse.dim_assessments
        ADD CONSTRAINT fk_dim_assessments_presentation
        FOREIGN KEY (presentation_id)
        REFERENCES warehouse.dim_module_presentations(presentation_id);
    END IF;
END $$;

----------------------------------------------------
-- dim_vles
----------------------------------------------------

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_dim_vles_presentation'
    ) THEN
        ALTER TABLE warehouse.dim_vles
        ADD CONSTRAINT fk_dim_vles_presentation
        FOREIGN KEY (presentation_id)
        REFERENCES warehouse.dim_module_presentations(presentation_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_dim_vles_activity_type'
    ) THEN
        ALTER TABLE warehouse.dim_vles
        ADD CONSTRAINT fk_dim_vles_activity_type
        FOREIGN KEY (vle_activity_type_id)
        REFERENCES warehouse.dim_vle_activity_types(vle_activity_type_id);
    END IF;
END $$;

----------------------------------------------------
-- FACT TABLES
----------------------------------------------------

-- fact_student_registrations

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_fact_registration_student'
    ) THEN
        ALTER TABLE warehouse.fact_student_registrations
        ADD CONSTRAINT fk_fact_registration_student
        FOREIGN KEY (student_id)
        REFERENCES warehouse.dim_students(student_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_fact_registration_presentation'
    ) THEN
        ALTER TABLE warehouse.fact_student_registrations
        ADD CONSTRAINT fk_fact_registration_presentation
        FOREIGN KEY (presentation_id)
        REFERENCES warehouse.dim_module_presentations(presentation_id);
    END IF;
END $$;

----------------------------------------------------
-- fact_student_assessments
----------------------------------------------------

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_fact_assessment_student'
    ) THEN
        ALTER TABLE warehouse.fact_student_assessments
        ADD CONSTRAINT fk_fact_assessment_student
        FOREIGN KEY (student_id)
        REFERENCES warehouse.dim_students(student_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_fact_assessment_assessment'
    ) THEN
        ALTER TABLE warehouse.fact_student_assessments
        ADD CONSTRAINT fk_fact_assessment_assessment
        FOREIGN KEY (assessment_id)
        REFERENCES warehouse.dim_assessments(assessment_id);
    END IF;
END $$;

----------------------------------------------------
-- fact_student_vles
----------------------------------------------------

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_fact_vle_student'
    ) THEN
        ALTER TABLE warehouse.fact_student_vles
        ADD CONSTRAINT fk_fact_vle_student
        FOREIGN KEY (student_id)
        REFERENCES warehouse.dim_students(student_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_fact_vle_vle'
    ) THEN
        ALTER TABLE warehouse.fact_student_vles
        ADD CONSTRAINT fk_fact_vle_vle
        FOREIGN KEY (vle_id)
        REFERENCES warehouse.dim_vles(vle_id);
    END IF;
END $$;

----------------------------------------------------
-- MART TABLES
----------------------------------------------------

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_mart_student'
    ) THEN
        ALTER TABLE mart.mart_student_performance
        ADD CONSTRAINT fk_mart_student
        FOREIGN KEY (student_id)
        REFERENCES warehouse.dim_students(student_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_mart_module'
    ) THEN
        ALTER TABLE mart.mart_student_performance
        ADD CONSTRAINT fk_mart_module
        FOREIGN KEY (module_id)
        REFERENCES warehouse.dim_modules(module_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_mart_presentation'
    ) THEN
        ALTER TABLE mart.mart_student_performance
        ADD CONSTRAINT fk_mart_presentation
        FOREIGN KEY (presentation_id)
        REFERENCES warehouse.dim_module_presentations(presentation_id);
    END IF;
END $$;

COMMIT;