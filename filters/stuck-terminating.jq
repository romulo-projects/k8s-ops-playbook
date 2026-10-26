# deletionTimestamp can include the grace period: only report overdue deletion.
["namespace","pod","deletionTimestamp","overdueSeconds"],
(.items[] | select(.metadata.deletionTimestamp != null)
 | ($now - (.metadata.deletionTimestamp | fromdateiso8601)) as $age
 | select($age > $threshold)
 | [.metadata.namespace, .metadata.name, .metadata.deletionTimestamp, ($age | floor)]) | @csv
