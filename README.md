# AfiLearn: Multi-Engine Learning Analytics Data Platform

An end-to-end learning analytics data engineering platform built on the Open University Learning Analytics Dataset (OULAD). This project implements a modern multi-engine architecture combining **Relational ELT (PostgreSQL + dbt)**, **NoSQL Document Modeling (MongoDB)**, and **Distributed Big Data Processing (Apache PySpark)** to answer critical educational questions at scale.

---

## 1. Environment Setup & Prerequisites

Before running the pipelines, ensure your local system meets the following prerequisites:

- **OS**: macOS / Linux / Windows (WSL2)
- **Python**: 3.10 or higher
- **Docker & Docker Compose**: Required for running local PostgreSQL and MongoDB instances
- **Java Runtime Environment (JRE)**: OpenJDK 8, 11, 17, or **21 LTS** required for Apache PySpark

### Step 1: Clone & Configure Virtual Environment
It is strongly recommended to use an isolated Python virtual environment:
```bash
# Create the virtual environment
python3 -m venv .venv

# Activate the virtual environment
source .venv/bin/activate  # On macOS/Linux
# .venv\Scripts\activate   # On Windows
```

### Step 2: Install Python Dependencies
Install all core data engineering, database drivers, dbt modules, NoSQL libraries, and PySpark packages:
```bash
pip install --upgrade pip
pip install -r requirements.txt
```

### Step 3: Configure Environment Variables
Copy the example environment file and verify database connection parameters:
```bash
cp .envexample .env
```
*The default `.env` configuration connects seamlessly to the local Docker containers launched in Step 4.*

### Step 4: Launch Database Infrastructure (Docker)
Start the PostgreSQL data warehouse and MongoDB instance using Docker Compose:
```bash
docker-compose up -d
```
This launches:
- **PostgreSQL**: Port `5432` (User: `postgres`, Password: `password`, DB: `warehouse`)
- **MongoDB**: Port `27017` (User: `root`, Password: `password`, DB: `afilearn_nosql`)

### Step 5: Java LTS Setup for PySpark
Apache Spark requires a Long-Term Support (LTS) Java version (Java 8, 11, 17, or 21). Newer non-LTS releases (such as Java 24 or Java 26) remove internal memory classes (`jdk.internal.ref.Cleaner`) required by Spark.

On macOS with Homebrew, install OpenJDK 21:
```bash
brew install openjdk@21
```
*Note: Our PySpark execution scripts automatically detect installed LTS Java runtimes (`openjdk@21`, `openjdk@17`, `openjdk@11`) and inject necessary `--add-opens` JVM memory flags so you do not need to manually configure environment variables.*

---

## 2. Pipeline Execution Guide

All execution scripts are located in the `scripts/` directory and automatically detect and activate your `.venv` virtual environment.

### Option A: Complete End-to-End Automated Pipeline
To execute all layers of the relational warehouse sequentially (Raw Ingestion $\rightarrow$ Staging $\rightarrow$ Star Schema Warehouse $\rightarrow$ Analytical Marts):
```bash
./scripts/run_pipeline.sh
```

### Option B: Modular Step-by-Step Execution
You can run specific paradigms or layers independently depending on your analysis needs:

#### 1. Relational ELT Data Warehouse (dbt + PostgreSQL)
```bash
# 1. Load raw OULAD CSV files into PostgreSQL raw tables
./scripts/loader.sh

# 2. Transform and clean raw data into staging models (views)
./scripts/run_staging.sh

# 3. Build star-schema dimension and fact tables (with row-level deduplication)
./scripts/run_warehouse.sh

# 4. Generate aggregated analytical data marts
./scripts/run_marts.sh
```

#### 2. NoSQL Document Database Pipeline (MongoDB)
Ingests relational course, demographic, assessment, and clickstream data into rich, student-centric JSON/BSON hierarchical documents:
```bash
./scripts/run_nosql.sh
```

#### 3. Big Data Processing Pipeline (Apache PySpark)
Runs distributed in-memory analytics across 10+ million clickstream and assessment records, exporting optimized columnar `.parquet` data marts:
```bash
./scripts/run_bigdata.sh
```

---

## 3. Analytical Questions & Engine Implementations

Each database paradigm in AfiLearn is intentionally selected to answer specific categories of learning analytics questions based on data structure, volume, and query patterns.

### 🏛️ Paradigm 1: Relational ELT Data Warehouse (PostgreSQL + dbt)
**Implementation**: Implements a structured Medallion Architecture (`raw` $\rightarrow$ `staging` $\rightarrow$ `warehouse` $\rightarrow$ `mart`). Utilizes surrogate keys, window-function deduplication (`row_number()`), and strict foreign-key relationships to ensure data integrity across historical enrollments.

**Questions We Answer**:
1. **Academic Performance Correlation**: *How do assessment completion rates, average scores, and VLE interaction volumes correlate with final course outcomes (Pass, Distinction, Fail, Withdrawn)?*
   - Answered via `mart_student_performance`, which joins dimension attributes with aggregated student facts.
2. **Historical Attrition Tracking**: *Which specific modules and course presentations exhibit the highest historical failure and withdrawal rates?*
3. **Repeat Student Behavior**: *How does a student's number of previous attempts affect their likelihood of passing on subsequent enrollments?*
4. **Assessment Weighting Impact**: *Are students failing modules due to low scores on high-weight exams, or due to missing low-weight continuous assessments?*

---

### 🍃 Paradigm 2: NoSQL Document Database (MongoDB)
**Implementation**: Implements a denormalized **Student 360 Profile** document schema (`nosql/src/`). Instead of joining 7 relational tables, all demographic attributes, course enrollment histories, nested assessment submissions, and clickstream summaries are embedded into a single JSON/BSON document per student.

**Questions We Answer**:
1. **Real-Time At-Risk Student Identification**: *How can we rapidly query active students within a specific course module who exhibit BOTH failing grade trajectories (average score < 50) AND low digital platform engagement (VLE clicks < 100)?*
   - Solved via `query_at_risk_students()` using MongoDB compound `$or` queries on embedded document fields without relational join overhead.
2. **Behavioral Segmentation by Outcome**: *What is the exact relationship between digital engagement (vle clicks) and academic score across different cohort outcomes?*
   - Solved via `aggregate_engagement_by_outcome()` using MongoDB Aggregation Pipelines (`$group`, `$avg`, `$sort`).
3. **High-Performer Profiling**: *Who are the top-performing students achieving Distinctions with high assessment completion rates across multiple modules?*
   - Solved via `query_high_performers()` leveraging compound indices on nested metric fields.

---

### ⚡ Paradigm 3: Big Data Distributed Processing (Apache PySpark)
**Implementation**: Implements distributed in-memory data processing (`bigdata/src/`) designed to handle high-volume event logging (such as the 10.6+ million records in `student_vle.csv` and `student_assessment.csv`) that would cause bottlenecks in traditional OLTP relational databases. Outputs partitioned `.parquet` files for downstream BI tools.

**Questions We Answer**:
1. **Course Presentation Difficulty & Attrition Index**: *What is the structural difficulty index of each course presentation over time, and how do pass/fail ratios shift across academic years?*
   - Solved via **Job 1** (`job_module_presentation_difficulty.py`), calculating global percentage distributions across millions of registrations.
2. **The 80/20 Learning Resource Pareto Distribution**: *Does student interaction with online learning resources follow the Pareto Principle (80/20 Rule), and which specific virtual platform tools drive the vast majority of engagement?*
   - Solved via **Job 2** (`job_learning_resource_pareto.py`), aggregating 39+ million clicks across 2,600+ VLE sites to prove that just **4 resource types** (`oucontent`, `forumng`, `quiz`, and `homepage`) account for **83.61% of all platform traffic**.
3. **Early-Warning Disengagement Velocity Detection**: *Can we detect immediate drop-offs in student learning velocity before they formally withdraw or fail an assessment?*
   - Solved via **Job 3** (`job_student_engagement_velocity.py`), using PySpark window functions (`lag()`) across time-series week offsets to flag students experiencing severe week-over-week engagement declines (**>50% drop in clicks**), enabling automated early intervention alerts.

---

## 4. Project Repository Structure

```text
afilearn/
├── .env / .envexample         # Environment configuration and DB credentials
├── docker-compose.yml         # Local infrastructure (PostgreSQL & MongoDB containers)
├── requirements.txt           # Python dependencies (dbt, PySpark, pymongo, etc.)
├── README.md                  # Project documentation
├── data/                      # Data storage
│   ├── dataset.zip            # Compressed OULAD source archive
│   ├── raw/                   # Extracted raw CSV files
│   └── processed/
│       └── bigdata_marts/     # PySpark output Parquet analytical marts
├── scripts/                   # Executable bash pipelines and utilities
│   ├── common.sh              # Shared logging, environment detection, and virtualenv activation
│   ├── loader.sh              # Relational CSV loader
│   ├── run_staging.sh         # dbt staging pipeline runner
│   ├── run_warehouse.sh       # dbt star-schema warehouse runner
│   ├── run_marts.sh           # dbt analytical mart runner
│   ├── run_pipeline.sh        # Complete relational ELT automation
│   ├── run_nosql.sh           # MongoDB ingestion & analytics runner
│   └── run_bigdata.sh         # PySpark distributed processing runner
├── transform/                 # dbt (Data Build Tool) project
│   ├── dbt_project.yml        # dbt configuration
│   └── models/
│       ├── staging/           # View transformations and data cleaning
│       ├── warehouse/         # Dimension and fact tables (Star Schema)
│       └── mart/              # Aggregated business logic and reporting marts
├── nosql/                     # MongoDB NoSQL implementation
│   └── src/
│       ├── config/            # MongoDB connection management
│       ├── etl/               # Document transformation and data modeling
│       ├── load/              # Bulk document ingestion
│       ├── analytics/         # MongoDB aggregation pipelines and nested queries
│       └── main.py            # NoSQL entry point
└── bigdata/                   # Apache PySpark Big Data implementation
    └── src/
        ├── config/            # SparkSession builder & LTS Java detection
        ├── jobs/              # Distributed Spark analytical jobs (Pareto, Velocity, Difficulty)
        └── main.py            # Big Data orchestration entry point
```
