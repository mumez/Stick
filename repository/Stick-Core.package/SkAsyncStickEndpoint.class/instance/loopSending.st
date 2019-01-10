private
loopSending
	[ self shouldLoopSending ] whileTrue: [ self sendData ].
	self shutdown 