actions
send: bytes
	self errorHandlingDo: [self sendQueue nextPut:  bytes]