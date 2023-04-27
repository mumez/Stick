actions
connect
	self socketIsConnected ifTrue: [ ^true ].
	^ self reconnectMutex critical: [  
		self basicConnect
	]
	