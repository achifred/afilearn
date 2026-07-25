#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

log "Building MART models"

cd "$PROJECT_ROOT/transform"

dbt build --select tag:mart