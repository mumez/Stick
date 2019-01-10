receiving
receiveData
	| sockStream bytes |
	self shouldEndReconnecting ifTrue: [ ^self stick release ].
	sockStream := self socketStream ifNil: [ ^self ].
	self errorHandlingDo: [ 
		[bytes := self onReceiveBlock value: sockStream] on: ConnectionTimedOut do: [:ex | self logger debug: ex ]
	].
	bytes ifNotNil: [ self onDataReceived: bytes]