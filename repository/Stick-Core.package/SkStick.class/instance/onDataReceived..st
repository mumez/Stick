event-handling
onDataReceived: data
	self onDataBlock ifNotNil: [ :block | block value: data ]