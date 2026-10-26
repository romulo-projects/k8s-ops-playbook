["namespace","pod","container","source","finishedAt"],
(.items[] | .metadata as $m
 | ((.status.containerStatuses // []) + (.status.initContainerStatuses // []))[]
 | .name as $container
 | {source: "current", termination: .state.terminated},
   {source: "previous", termination: .lastState.terminated}
 | select(.termination.reason == "OOMKilled")
 | [$m.namespace, $m.name, $container, .source, .termination.finishedAt]) | @csv
