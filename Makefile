VENV := dbt-duckdb-env
DBT_PROJECT := dbt_claude_test
PYTHON := $(VENV)/bin/python
DBT := $(VENV)/bin/dbt

.PHONY: help install dbt-deps dbt-compile dbt-run dbt-test dbt-build dbt-docs notebook clean

help:
	@echo "Available commands:"
	@echo "  make install      Install Python dependencies into venv"
	@echo "  make dbt-deps     Install dbt packages"
	@echo "  make dbt-compile  Compile dbt models (no execution)"
	@echo "  make dbt-run      Run all dbt models"
	@echo "  make dbt-test     Run all dbt tests"
	@echo "  make dbt-build    Run + test all models in dependency order"
	@echo "  make dbt-docs     Generate and serve dbt docs (localhost:8080)"
	@echo "  make notebook     Launch Jupyter notebook server"
	@echo "  make clean        Remove dbt target/ and dbt_packages/"

install:
	$(PYTHON) -m pip install --upgrade pip
	$(PYTHON) -m pip install -r requirements.txt

dbt-deps:
	cd $(DBT_PROJECT) && $(CURDIR)/$(DBT) deps

dbt-compile:
	cd $(DBT_PROJECT) && $(CURDIR)/$(DBT) compile

dbt-run:
	cd $(DBT_PROJECT) && $(CURDIR)/$(DBT) run

dbt-test:
	cd $(DBT_PROJECT) && $(CURDIR)/$(DBT) test

dbt-build:
	cd $(DBT_PROJECT) && $(CURDIR)/$(DBT) build

dbt-docs:
	cd $(DBT_PROJECT) && $(CURDIR)/$(DBT) docs generate && $(CURDIR)/$(DBT) docs serve --port 8080

notebook:
	$(PYTHON) -m jupyter notebook notebooks/

clean:
	cd $(DBT_PROJECT) && $(CURDIR)/$(DBT) clean
