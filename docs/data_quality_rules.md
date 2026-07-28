# Data Quality Rules for the OULAD ELT Pipeline

## Pipeline Overview

``` text
CSV Files
    │
    ▼
Python Loader
    │
    ▼
raw schema
    │
    ▼
dbt staging
    │
    ▼
staging schema
    │
    ▼
dbt warehouse
(dimensions + facts)
    │
    ▼
warehouse schema
    │
    ▼
dbt marts
    │
    ▼
mart schema
```

## 1. File Quality (Python Loader)

-   Verify each expected CSV file exists.
-   Reject empty files.
-   Validate required headers.
-   Validate delimiter (`,`).
-   Validate UTF-8 encoding.
-   Prevent duplicate/reprocessed files.
-   Log rows loaded and rejected.

## 2. Raw → Staging Quality

-   Replace placeholder values (e.g. `?`) with `NULL`.
-   Standardise boolean values (`Y/N`, `1/0`, etc.).
-   Cast columns to correct data types.
-   Trim whitespace.
-   Standardise categorical text (e.g. `Pass`, `Fail`).
-   Remove duplicate records.

## 3. Dimension Table Quality

-   Primary keys must be unique.
-   Primary keys must not be `NULL`.
-   Business keys (e.g. `module_code`) must be unique.
-   Validate numeric ranges:
    -   Age: 0--120
    -   Study credits ≥ 0
    -   Assessment weight: 0--100
-   Validate accepted values:
    -   Final result: Pass, Fail, Withdrawn, Distinction
    -   Assessment type: TMA, CMA, Exam

## 4. Fact Table Quality

-   Every foreign key must reference an existing dimension record.
-   Prevent duplicate fact rows at the defined grain.
-   Validate:
    -   Score between 0 and 100.
    -   `sum_click >= 0`.

## 5. Mart Quality

-   One row per defined grain.
-   Aggregated metrics should not be `NULL`.
-   Validate reconciliation:
    -   Average score matches fact table.
    -   Total clicks matches fact table.

## 6. Cross-table Business Rules

-   Assessment weights per presentation total 100.
-   Students cannot submit assessments without registration.
-   Registration date precedes unregistration date.
-   Every assessment belongs to an existing presentation.
-   Every presentation belongs to exactly one module.
-   Age band lower bound ≤ upper bound.
-   IMD band lower percentage ≤ upper percentage.

## 7. Pipeline Quality

1.  Python loader validates files and loads raw data.
2.  Run `dbt build` / `dbt test` for staging.
3.  Run `dbt build` / `dbt test` for warehouse.
4.  Create foreign keys and indexes.
5.  Run `dbt build` / `dbt test` for marts.
6.  Fail the pipeline on critical data quality errors.


-   Validate files before loading.
-   Clean and standardise data in staging.
-   Enforce uniqueness and non-null constraints in dimensions.
-   Enforce referential integrity and valid ranges in facts.
-   Validate mart aggregations.
-   Execute `dbt test` after each transformation layer.
-   Stop the pipeline if critical tests fail.
