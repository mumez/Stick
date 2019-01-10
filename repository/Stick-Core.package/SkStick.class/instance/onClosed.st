event-handling
onClosed
	status := SkStickStatus closed.
	self onClosedBlock ifNotNil: [ :block | block cull: self ]