CREATE EXTENSION IF NOT EXISTS 'pgcrypto';

CREATE TABLE IF NOT EXISTS modules(
    module_id SERIAL PRIMARY KEY,
    module_code VARCHAR(10) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS presentations(
    presentation_id SERIAL PRIMARY KEY,
    module_id BIGINT NOT NULL,
    presentation_code VARCHAR(10) NOT NULL,
    presentation_length INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_module_id_presentation FOREIGN KEY(module_id) REFERENCES modules(module_id),
);

-- CREATE TABLE IF NOT EXISTS module_presentations(
--     module_presentation_id SERIAL PRIMARY KEY,
--     module_id BIGINT NOT NULL,
--     presentation_id BIGINT NOT NULL,
--     module_presentation_length INT,
--     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
--     CONSTRAINT fk_presentation_id_module_presentation FOREIGN KEY(presentation_id) REFERENCES presentations(presentation_id)
-- );

CREATE TABLE IF NOT EXISTS students(
    student_id BIGINT PRIMARY KEY,
    region VARCHAR(100),
    highest_education VARCHAR(200),
    idm_band VARCHAR(20),
    age_band VARCHAR(20),
    disability VARCHAR(10) DEFAULT 'N',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS registrations(
    registration_id SERIAL PRIMARY KEY,
    student_id BIGINT NOT NULL,
    module_presentation_id BIGINT NOT NULL,
    number_of_prev_attempts INT DEFAULT 0,
    studied_credits INT,
    registration_date_offset INT,
    unregistered_date_offset INT,
    final_result VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_student_id_registration FOREIGN KEY(student_id) REFERENCES student(student_id),
    CONSTRAINT fk_module_presentation_id_registration FOREIGN KEY(module_presentation_id) REFERENCES module_presentations(module_presentation_id)
);

CREATE TABLE IF NOT EXISTS assessments(
    assessment_id BIGINT PRIMARY KEY,
    module_presentation_id BIGINT NOT NULL,
    assessment_type VARCHAR(10) NOT NULL,
    submission_date_offset INT,
    assessment_weight INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_module_presentation_id_assessment FOREIGN KEY(module_presentation_id) REFERENCES module_presentations(module_presentation_id)
);

CREATE TABLE IF NOT EXISTS student_assessments(
    student_assessment_id SERIAL PRIMARY KEY,
    student_id BIGINT NOT NULL,
    assessment_id BIGINT NOT NULL,
    date_submitted_offset VARCHAR(10),
    is_banked BOOLEAN DEFAULT FALSE,
    score INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_student_id_studentassessment FOREIGN KEY(student_id) REFERENCES students(student_id),
    CONSTRAINT fk_assessment_id_studentassessment FOREIGN KEY(assessment_id) REFERENCES assessments(assessment_id)
);

CREATE TABLE IF NOT EXISTS vleactivitytypes(
    vle_activity_type_id SERIAL PRIMARY KEY,
    vle_activity_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS vles(
    vle_id BIGINT PRIMARY KEY,
    module_presentation_id BIGINT NOT NULL,
    activity_type_id BIGINT NOT NULL,
    week_from VARCHAR(10),
    week_to VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_module_presentation_id_vle FOREIGN KEY(module_presentation_id) REFERENCES module_presentations(module_presentation_id),
    CONSTRAINT fk_activity_type_id_vle FOREIGN KEY(activity_type_id) REFERENCES vleactivitytypes(vle_activity_type_id)

);

CREATE TABLE IF NOT EXISTS student_vles(
    student_vle_id SERIAL PRIMARY KEY,
    student_id BIGINT NOT NULL,
    vle_id BIGINT NOT NULL, 
    access_date_offset VARCHAR(10),
    sum_click INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_student_id_studentvle FOREIGN KEY(student_id) REFERENCES students(student_id),
    CONSTRAINT fk_vle_id_studentvle FOREIGN KEY(vle_id) REFERENCES vles(vle_id)
);