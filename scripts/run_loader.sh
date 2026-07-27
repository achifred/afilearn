#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

log "Loading CSV files into RAW schema"

cd "$PROJECT_ROOT"/ingestion

python -m src.main