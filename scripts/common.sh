#!/bin/bash

# Check dependencies
check_dependencies() {
  command -v kubectl >/dev/null 2>&1 || { echo "kubectl not installed"; exit 1; }
  command -v jq >/dev/null 2>&1 || { echo "jq not installed"; exit 1; }
}

# Default cutoff (30 days)
default_cutoff() {
  date -u -d '1 month ago' +%Y-%m-%dT%H:%M:%SZ
}