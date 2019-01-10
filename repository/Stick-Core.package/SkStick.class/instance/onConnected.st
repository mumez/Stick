event-handling
onConnected
	status := SkStickStatus connected.
	self onConnectedBlock ifNotNil: [ :block | block cull: self ]