receiving
receiveData
	| sockStream bytes |
	self shouldEndReconnecting ifTrue: [ ^self stick release ].
	sockStream := self socketStream ifNil: [ self waitFor: 3 . ^self ].
	sockStream isConnected ifFalse: [ self waitFor: 3 ].
	self errorHandlingDo: [ 
		[bytes := self onReceiveBlock value: sockStream] on: ConnectionTimedOut do: [:ex | self logger debug: ex ]
	].
	bytes ifNotNil: [ self onDataReceived: bytes]