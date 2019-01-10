actions
send: bytes
	| received |
	received := nil.
	self
		errorHandlingDo: [self socketStream nextPutAll: bytes.
			onReceiveBlock ifNotNil: [ received := onReceiveBlock value: self socketStream ] ].
	received ifNotNil: [ self onDataReceived: received ].
	^ received