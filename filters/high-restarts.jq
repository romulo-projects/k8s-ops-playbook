["namespace","pod","container","restartCount"],
(.items[] | .metadata as $m
 | ((.status.containerStatuses // []) + (.status.initContainerStatuses // []))[]
 | select((.restartCount // 0) > 5)
 | [$m.namespace, $m.name, .name, .restartCount]) | @csv
