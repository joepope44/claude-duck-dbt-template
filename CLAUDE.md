# CLAUDE.md — Project Guide

## Project Overview
A data science project using Python, dbt, and DuckDB as the analytical data warehouse.

- **dbt project**: `dbt_claude_test/`
- **Database**: DuckDB (file-based, local)
  - Dev DB: `dbt_claude_test/dev.duckdb`
  - Prod DB: `dbt_claude_test/prod.duckdb`
- **Python env**: `dbt-duckdb-env/` (Python 3.9)
- **dbt profile**: `dbt_claude_test` (configured in `~/.dbt/profiles.yml`)

## Folder Structure

```
.
├── CLAUDE.md               # This file
├── Makefile                # Common commands
├── requirements.txt        # Python dependencies
├── .env.example            # Environment variable template
├── data/
│   ├── raw/                # Source/input data files (CSV, JSON, Parquet, etc.)
│   ├── processed/          # Cleaned/transformed outputs
│   └── external/           # External reference data
├── notebooks/              # Jupyter notebooks for EDA and analysis
├── scripts/                # One-off Python scripts (ingestion, export, etc.)
├── src/                    # Reusable Python package (helpers, DB connectors)
└── dbt_claude_test/        # dbt project
    ├── models/
    │   ├── staging/        # Raw → typed: one model per source table
    │   ├── intermediate/   # Business logic joins and transformations
    │   └── marts/          # Final analytical tables/views for consumption
    ├── seeds/              # Static CSV reference data loaded into DuckDB
    ├── macros/             # Reusable Jinja/SQL macros
    ├── tests/              # Singular data tests
    ├── snapshots/          # SCD Type 2 snapshots
    └── analyses/           # Ad-hoc SQL analyses (not materialized)
```

## dbt Model Conventions

- **staging/**: Prefix models with `stg_<source>__<table>.sql`. Materialized as views.
- **intermediate/**: Prefix with `int_<description>.sql`. Materialized as views (ephemeral also fine).
- **marts/**: Prefix with `fct_` (facts) or `dim_` (dimensions). Materialized as tables.
- Always use `{{ ref() }}` to reference other models and `{{ source() }}` for raw sources.
- Add tests (unique, not_null, etc.) in schema.yml files within each model folder.

## Common Commands

Activate the Python environment first:
```bash
source dbt-duckdb-env/bin/activate
```

Or use the Makefile shortcuts:
```bash
make dbt-run       # Run all dbt models
make dbt-test      # Run all dbt tests
make dbt-compile   # Compile without executing
make dbt-docs      # Generate and serve dbt docs
make notebook      # Launch Jupyter
make clean         # Remove dbt target/ and dbt_packages/
```

## Running dbt Manually

```bash
cd dbt_claude_test

dbt deps                        # Install packages from packages.yml
dbt compile                     # Compile SQL, no execution
dbt run                         # Run all models
dbt run -s staging              # Run only staging layer
dbt test                        # Run all tests
dbt build                       # Run + test in dependency order
dbt docs generate && dbt docs serve
```

## Working with DuckDB Directly

```python
import duckdb

# Connect to dev database
con = duckdb.connect("dbt_claude_test/dev.duckdb")
con.execute("SHOW TABLES").fetchall()
```

## Adding New Data Sources

1. Place raw files in `data/raw/`
2. Register the source in `dbt_claude_test/models/sources.yml`
3. Create a staging model in `models/staging/stg_<source>__<table>.sql`
4. Add tests and documentation to `models/staging/schema.yml`
