event-handling
onErrorSignaled: anException
	self onErrorBlock ifNotNil: [ :block | block cull: anException cull: self]