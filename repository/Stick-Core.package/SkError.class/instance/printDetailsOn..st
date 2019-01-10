printing
printDetailsOn: aStream
	self kind ifNotNil: [aStream nextPutAll: self kind asString].
	self otherInfo ifNotEmpty: [aStream space; nextPutAll: self otherInfo asString]