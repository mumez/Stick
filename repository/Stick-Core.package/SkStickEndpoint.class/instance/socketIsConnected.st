testing
socketIsConnected
	self socketStream ifNil: [ ^false ].
	^ self socketStream isConnected