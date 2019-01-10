private
loopReceiving
	[ self shouldLoopReceiving ] whileTrue: [ self receiveData ].
	self shutdown 