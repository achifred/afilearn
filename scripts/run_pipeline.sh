#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo
echo "=========================================="
echo "Starting ELT Pipeline"
echo "=========================================="

"$SCRIPT_DIR/loader.sh"

"$SCRIPT_DIR/run_staging.sh"

"$SCRIPT_DIR/run_warehouse.sh"

"$SCRIPT_DIR/run_marts.sh"

echo
echo "=========================================="
echo "ELT Pipeline completed successfully!"
echo "=========================================="
