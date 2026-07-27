#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

log "Running NoSQL (MongoDB) Student Learning Profile Pipeline"

cd "$PROJECT_ROOT"
export PYTHONPATH="$PROJECT_ROOT:${PYTHONPATH:-}"

python3 -m nosql.src.main
