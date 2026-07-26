CREATE SCHEMA IF NOT EXISTS raw;

SET search_path TO raw, public;

CREATE TABLE IF NOT EXISTS assessments(
    code_module VARCHAR(10) NOT NULL,
    code_presentation VARCHAR(10) NOT NULL,
    id_assessment VARCHAR(10) NOT NULL,
    assessment_type VARCHAR(10) NOT NULL,
    "date" VARCHAR(10) NOT NULL,
    weight VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS student_assessments(
    id_assessment VARCHAR(10) NOT NULL,
    id_student VARCHAR(10) NOT NULL,
    date_submitted VARCHAR(10) NOT NULL,
    is_banked VARCHAR(5),
    score VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS courses(
    code_module VARCHAR(10) NOT NULL,
    code_presentation VARCHAR(10) NOT NULL,
    module_presentation_length VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS student_info(
    code_module VARCHAR(10) NOT NULL,
    code_presentation VARCHAR(10) NOT NULL,
    id_student VARCHAR(10) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    region VARCHAR(100),
    highest_education VARCHAR(100),
    imd_band VARCHAR(10),
    age_band VARCHAR(10),
    num_of_prev_attempts VARCHAR(10),
    studied_credits VARCHAR(10),
    disability VARCHAR(10) DEFAULT 'N',
    final_result VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS student_registrations(
    code_module VARCHAR(10) NOT NULL,
    code_presentation VARCHAR(10) NOT NULL,
    id_student VARCHAR(10) NOT NULL,
    date_registration VARCHAR(10),
    date_unregistration VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS vles(
    id_site VARCHAR(10) NOT NULL,
    code_module VARCHAR(10) NOT NULL,
    code_presentation VARCHAR(10) NOT NULL,
    activity_type VARCHAR(100),
    week_from VARCHAR(10),
    week_to VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS student_vles(
    code_module VARCHAR(10),
    code_presentation VARCHAR(10),
    id_student VARCHAR(10) NOT NULL,
    id_site VARCHAR(10) NOT NULL,
    "date" VARCHAR(10),
    sum_click VARCHAR(10)
);
