#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

log "Building WAREHOUSE models"

cd "$PROJECT_ROOT/transform"

dbt build --select tag:warehouse