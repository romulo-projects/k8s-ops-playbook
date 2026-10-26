#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"
command -v jq >/dev/null || { echo 'Install jq 1.6+ to run tests' >&2; exit 1; }
count=0
check() {
  local name=$1 filter=$2 input=$3 expected=$4 actual
  shift 4
  actual=$(printf '%s' "$input" | jq -br "$@" -f "filters/$filter.jq")
  if [[ $actual != "$expected" ]]; then
    printf 'FAIL: %s\nExpected:\n%s\nActual:\n%s\n' "$name" "$expected" "$actual" >&2
    exit 1
  fi
  count=$((count + 1))
  printf 'PASS: %s\n' "$name"
}
restarts='"namespace","pod","container","restartCount"'
resources='"namespace","pod","container","requestCPU","requestMemory","limitCPU","limitMemory"'
terminating='"namespace","pod","deletionTimestamp","overdueSeconds"'
oom='"namespace","pod","container","source","finishedAt"'
capacity='"namespace","pvc","requestedStorage","provisionedCapacity","phase"'
check 'empty cluster' high-restarts '{"items":[]}' "$restarts"
check 'pod without status' high-restarts '{"items":[{}]}' "$restarts"
check 'restart threshold and init containers' high-restarts \
  '{"items":[{"metadata":{"namespace":"dev","name":"api"},"status":{"containerStatuses":[{"name":"app","restartCount":6},{"name":"sidecar","restartCount":5}],"initContainerStatuses":[{"name":"init","restartCount":9}]}}]}' \
  "$restarts"$'\n"dev","api","app",6\n"dev","api","init",9'
check 'empty resource maps are missing' missing-resources \
  '{"items":[{"metadata":{"namespace":"dev","name":"api"},"spec":{"containers":[{"name":"app","resources":{"requests":{},"limits":{}}}]}}]}' \
  "$resources"$'\n"dev","api","app",,,,'
check 'partial resources' missing-resources \
  '{"items":[{"metadata":{"namespace":"dev","name":"api"},"spec":{"containers":[{"name":"app","resources":{"requests":{"cpu":"100m"},"limits":{"memory":"128Mi"}}}]}}]}' \
  "$resources"$'\n"dev","api","app","100m",,,"128Mi"'
check 'complete resources excluded' missing-resources \
  '{"items":[{"spec":{"containers":[{"resources":{"requests":{"cpu":"100m","memory":"64Mi"},"limits":{"cpu":"1","memory":"128Mi"}}}]}}]}' "$resources"
check 'normal and recent deletion excluded' stuck-terminating \
  '{"items":[{}, {"metadata":{"deletionTimestamp":"2023-11-14T22:10:00Z"}}, {"metadata":{"deletionTimestamp":"2023-11-14T22:20:00Z"}}]}' \
  "$terminating" --argjson now 1700000000 --argjson threshold 300
check 'overdue deletion' stuck-terminating \
  '{"items":[{"metadata":{"namespace":"dev","name":"api","deletionTimestamp":"2023-11-14T22:00:00Z"}}]}' \
  "$terminating"$'\n"dev","api","2023-11-14T22:00:00Z",800' --argjson now 1700000000 --argjson threshold 300
check 'OOM without statuses' oomkilled '{"items":[{}]}' "$oom"
check 'previous OOM and current init OOM' oomkilled \
  '{"items":[{"metadata":{"namespace":"dev","name":"api"},"status":{"containerStatuses":[{"name":"app","lastState":{"terminated":{"reason":"OOMKilled","finishedAt":"2023-11-14T22:00:00Z"}}}],"initContainerStatuses":[{"name":"init","state":{"terminated":{"reason":"OOMKilled","finishedAt":"2023-11-14T22:00:00Z"}}}]}}]}' \
  "$oom"$'\n"dev","api","app","previous","2023-11-14T22:00:00Z"\n"dev","api","init","current","2023-11-14T22:00:00Z"'
check 'non OOM excluded' oomkilled '{"items":[{"status":{"containerStatuses":[{"state":{"terminated":{"reason":"Completed"}}}]}}]}' "$oom"
check 'pending PVC without capacity' pvc-capacity \
  '{"items":[{"metadata":{"namespace":"dev","name":"data"},"spec":{"resources":{"requests":{"storage":"1Gi"}}},"status":{"phase":"Pending"}}]}' \
  "$capacity"$'\n"dev","data","1Gi",,"Pending"'
check 'PVC requested and provisioned capacity' pvc-capacity \
  '{"items":[{"metadata":{"namespace":"dev","name":"data"},"spec":{"resources":{"requests":{"storage":"2Gi"}}},"status":{"phase":"Bound","capacity":{"storage":"1Gi"}}}]}' \
  "$capacity"$'\n"dev","data","2Gi","1Gi","Bound"'

# Exercise the real wrapper with a fake kubectl; no cluster access.
mockdir=$(mktemp -d)
trap 'rm -rf -- "$mockdir"' EXIT
cat > "$mockdir/kubectl" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' "$@" > "$MOCK_ARGS"
if [[ ${MOCK_FAIL:-0} == 1 ]]; then echo 'forbidden' >&2; exit 1; fi
printf '{"items":[]}'
MOCK
chmod +x "$mockdir/kubectl"
export MOCK_ARGS="$mockdir/args"
export PATH="$mockdir:$PATH"
[[ $(bash scripts/report.sh high-restarts dev) == "$restarts" ]]
[[ $(cat "$MOCK_ARGS") == $'get\npods\n-n\ndev\n-o\njson' ]]
[[ $(bash scripts/report.sh pvc-capacity) == "$capacity" ]]
[[ $(cat "$MOCK_ARGS") == $'get\npvc\n-A\n-o\njson' ]]
if MOCK_FAIL=1 bash scripts/report.sh high-restarts >/dev/null 2>&1; then
  echo 'FAIL: kubectl error was swallowed' >&2; exit 1
fi
for report in invalid ''; do
  if bash scripts/report.sh "$report" >/dev/null 2>&1; then exit 1; fi
done
if TERMINATING_THRESHOLD_SECONDS=abc bash scripts/report.sh stuck-terminating >/dev/null 2>&1; then exit 1; fi
[[ $(TERMINATING_THRESHOLD_SECONDS=000 bash scripts/report.sh stuck-terminating) == "$terminating" ]]
if bash scripts/report.sh high-restarts --all >/dev/null 2>&1; then exit 1; fi
echo "PASS: $count filter cases and wrapper scope, validation, failure propagation"
