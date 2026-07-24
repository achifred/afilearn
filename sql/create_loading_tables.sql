CREATE TABLE IF NOT EXISTS assessments(
    id BIGSERIAL PRIMARY KEY,
    code_module VARCHAR(10) NOT NULL,
    code_presentation VARCHAR(10) NOT NULL,
    id_assessment VARCHAR(10) NOT NULL,
    assessment_type VARCHAR(10) NOT NULL,
    "date" VARCHAR(10) NOT NULL,
    weight VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS student_assessments(
    id BIGSERIAL PRIMARY KEY,
    id_assessment VARCHAR(10) NOT NULL,
    id_student VARCHAR(10) NOT NULL,
    date_submitted VARCHAR(10) NOT NULL,
    is_banked BOOLEAN DEFAULT FALSE,
    score VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS courses(
    id BIGSERIAL PRIMARY KEY,
    code_module VARCHAR(10) NOT NULL,
    code_presentation VARCHAR(10) NOT NULL,
    module_presentation_length VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS student_info(
    id BIGSERIAL PRIMARY KEY,
    code_module VARCHAR(10) NOT NULL,
    code_presentation VARCHAR(10) NOT NULL,
    id_student VARCHAR(10) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    region VARCHAR(10),
    highest_education VARCHAR(10),
    imd_band VARCHAR(10),
    age_band VARCHAR(10),
    num_of_prev_attempts VARCHAR(10),
    studied_credits VARCHAR(10),
    disability VARCHAR(10) DEFAULT 'N',
    final_result VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS student_registrations(
    id BIGSERIAL PRIMARY KEY,
    code_module VARCHAR(10) NOT NULL,
    code_presentation VARCHAR(10) NOT NULL,
    id_student VARCHAR(10) NOT NULL,
    date_registration VARCHAR(10),
    date_unregistration VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS vles(
    id BIGSERIAL PRIMARY KEY,
    id_site VARCHAR(10) NOT NULL,
    code_module VARCHAR(10) NOT NULL,
    code_presentation VARCHAR(10) NOT NULL,
    activity_type VARCHAR(10),
    week_from VARCHAR(10),
    week_to VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS student_vles(
    id BIGSERIAL PRIMARY KEY,
    id_student VARCHAR(10) NOT NULL,
    id_site VARCHAR(10) NOT NULL,
    "date" VARCHAR(10),
    sum_click VARCHAR(10)
);
