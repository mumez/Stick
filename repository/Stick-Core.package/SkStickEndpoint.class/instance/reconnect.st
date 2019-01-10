actions
reconnect
	self reconnectMutex critical: [  
		self incrementReconnectTrials.
		self shouldEndReconnecting ifTrue: [
			^ self errorHandlingDo: [(SkReconnectEnded endpoint: self) signal].
	 	].
		self waitFor: (self nextReconnectIntervalSeconds).
		self connect.
	]