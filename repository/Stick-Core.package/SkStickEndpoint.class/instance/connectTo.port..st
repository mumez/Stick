actions
connectTo: ipAddr port: portNum
	self stick isConnected ifTrue: [ ^self ].
	socketStream := self errorHandlingDo: [ self createSocketStreamToHost: ipAddr port: portNum].
	socketStream ifNil: [ ^ false ].
	self onConnected.
	^ true