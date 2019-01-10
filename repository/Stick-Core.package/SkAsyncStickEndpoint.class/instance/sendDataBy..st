sending
sendDataBy: aSocketStream
	aSocketStream isConnected ifFalse: [ ^self ].
	[aSocketStream nextPutAll: self sendQueue next.
	aSocketStream flush] on: Error do: [ :ex | self stick release ]