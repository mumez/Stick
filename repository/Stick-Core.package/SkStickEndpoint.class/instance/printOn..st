printing
printOn: aStream
	aStream nextPutAll: self class name, '('.
	self printDetailsOn: aStream.
	aStream nextPut: $)