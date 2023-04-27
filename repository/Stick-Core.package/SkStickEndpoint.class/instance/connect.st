actions
connect
	self socketIsConnected ifTrue: [ ^true ].
	self reconnectMutex critical: [  
		| ipAddr |
		ipAddr := self
			errorHandlingDo: [ self portableUtil resolveAddress: self remoteHost timeout: self settings nameResolveTimeoutSeconds ].
		ipAddr ifNil: [ ^ false ].
		^ self connectTo: ipAddr port: self remotePortNumber
	]