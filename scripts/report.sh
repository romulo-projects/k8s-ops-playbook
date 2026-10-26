#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=scripts/common.sh
source "$root/scripts/common.sh"

usage() {
  echo 'Usage: bash scripts/report.sh {high-restarts|missing-resources|stuck-terminating|oomkilled|pvc-capacity} [namespace]' >&2
}
if (( $# < 1 || $# > 2 )); then usage; exit 2; fi
report=$1
case "$report" in
  high-restarts|missing-resources|stuck-terminating|oomkilled) resource=pods ;;
  pvc-capacity) resource=pvc ;;
  *) usage; exit 2 ;;
esac
check_dependencies
scope=(-A)
if (( $# == 2 )); then
  if [[ -z $2 || $2 == -* ]]; then echo 'Invalid namespace' >&2; exit 2; fi
  scope=(-n "$2")
fi
# Failures from kubectl propagate through the pipeline (pipefail).
args=()
if [[ $report == stuck-terminating ]]; then
  threshold=${TERMINATING_THRESHOLD_SECONDS:-300}
  if [[ ! $threshold =~ ^[0-9]+$ ]]; then
    echo 'TERMINATING_THRESHOLD_SECONDS must be a non-negative integer' >&2
    exit 2
  fi
  args=(--argjson now "$(date -u +%s)" --argjson threshold "$((10#$threshold))")
fi
kubectl get "$resource" "${scope[@]}" -o json | jq -br "${args[@]}" -f "$root/filters/$report.jq"
