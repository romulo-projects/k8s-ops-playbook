["namespace","pod","container","requestCPU","requestMemory","limitCPU","limitMemory"],
(.items[] | .metadata as $m | .spec.containers[]
 | [.resources.requests.cpu, .resources.requests.memory,
    .resources.limits.cpu, .resources.limits.memory] as $r
 | select(any($r[]; . == null))
 | [$m.namespace, $m.name, .name] + $r) | @csv
