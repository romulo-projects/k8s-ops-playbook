#!/bin/bash

# Check dependencies
check_dependencies() {
  command -v kubectl >/dev/null 2>&1 || { echo "kubectl not installed" >&2; return 1; }
  command -v jq >/dev/null 2>&1 || { echo "jq not installed" >&2; return 1; }
}

# Default cutoff: one calendar month ago. Requires GNU date.
default_cutoff() {
  date -u -d '1 month ago' +%Y-%m-%dT%H:%M:%SZ
}
