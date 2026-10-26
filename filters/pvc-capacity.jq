["namespace","pvc","requestedStorage","provisionedCapacity","phase"],
(.items[] | [.metadata.namespace, .metadata.name,
 .spec.resources.requests.storage, .status.capacity.storage, .status.phase]) | @csv
