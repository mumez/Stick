printing
printDetailsOn: aStream
	self remoteHost ifNotNil: [aStream nextPutAll: self remoteHost asString].
	self remotePortNumber ifNotNil: [aStream nextPut: $:; nextPutAll: self remotePortNumber  asString]