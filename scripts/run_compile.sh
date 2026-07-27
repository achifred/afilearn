#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

log "Compiling analyses files"

cd "$PROJECT_ROOT/transform"

dbt compile --select path:analyses