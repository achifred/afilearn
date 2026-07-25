#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

log "Loading CSV files into RAW schema"

cd "$PROJECT_ROOT"

python ingestion/src/main.py