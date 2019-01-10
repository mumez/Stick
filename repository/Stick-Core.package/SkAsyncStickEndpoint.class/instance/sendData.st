sending
sendData
	self socketStream
		ifNotNil:
			[ :sockStream | self errorHandlingDo: [ self sendDataBy: sockStream ] ]