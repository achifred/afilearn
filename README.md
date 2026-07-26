
# Project Setup and Data Pipeline

This project uses a series of shell scripts to build the data warehouse and data marts from raw data.

## Prerequisites

Before getting started, ensure you have:

- Python 3.10+ installed
- PostgreSQL running and accessible
- `pip` installed
- A virtual environment (recommended)

## 1. Install Dependencies

From the project root, install the required Python packages:

```bash
pip install -r requirements.txt
```

## 2. Configure Environment Variables

Create a `.env` file in the project root.

You can copy the provided example file:

```bash
cp .envexample .env
```

Open the `.env` file and update the values to match your local environment (database credentials, host, ports, etc.).

## 3. Run the Data Pipeline

Navigate to the `scripts` directory:

```bash
cd scripts
```

The following scripts are available:

### Load Raw Data

Loads the source data into the raw tables.

```bash
./loader.sh
```

### Populate Staging Tables

Transforms and loads data into the staging layer.

```bash
./run_staging.sh
```

### Build the Data Warehouse

Creates and populates the dimension and fact tables.

```bash
./run_warehouse.sh
```

### Build Data Marts

Creates the analytical data marts.

```bash
./run_marts.sh
```

### Run the Complete Pipeline

Executes the entire pipeline from raw data loading through data mart creation.

```bash
./run_pipeline.sh
```

## Pipeline Execution Order

The scripts should be run in the following order:

1. `loader.sh`
2. `run_staging.sh`
3. `run_warehouse.sh`
4. `run_marts.sh`

Alternatively, run the entire pipeline with:

```bash
./run_pipeline.sh
```

## Project Structure

```
project-root/
├── scripts/
│   ├── loader.sh
│   ├── run_staging.sh
│   ├── run_warehouse.sh
│   ├── run_marts.sh
│   └── run_pipeline.sh
├── .envexample
├── .env
├── requirements.txt
└── README.md
```
````



