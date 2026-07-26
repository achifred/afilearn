#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

log "Building STAGING models"

cd "$PROJECT_ROOT/transform"

dbt build --select tag:staging