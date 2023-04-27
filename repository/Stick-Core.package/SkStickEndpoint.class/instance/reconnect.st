actions
reconnect
	self socketIsConnected ifTrue: [ ^true ].
	self reconnectMutex critical: [  
		self incrementReconnectTrials.
		self shouldEndReconnecting ifTrue: [
			^ self errorHandlingDo: [(SkReconnectEnded endpoint: self) signal].
	 	].
		self waitFor: (self nextReconnectIntervalSeconds).
		self basicConnect.
	]