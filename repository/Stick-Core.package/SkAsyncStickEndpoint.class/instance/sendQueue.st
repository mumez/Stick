accessing
sendQueue
	^sendQueue ifNil: [ sendQueue := SharedQueue new ]