#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[ -d "$PROJECT_ROOT/.venv" ] && source "$PROJECT_ROOT/.venv/bin/activate"
LOG_DIR="$PROJECT_ROOT/logs"
export DBT_PROFILES_DIR="$PROJECT_ROOT"
mkdir -p "$LOG_DIR"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

cd "$PROJECT_ROOT/transform"
dbt deps
cd ..

log() {
    echo
    echo "================================================"
    echo "$1"
    echo "================================================"
}