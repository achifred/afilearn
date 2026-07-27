#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

log "Creating table indexes"

cd "$PROJECT_ROOT"/ingestion

python -m src.create_db_constraints
