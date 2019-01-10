printing
printOn: aStream
	aStream nextPutAll: self className.
	aStream nextPutAll: ' (' , self statusString , ')'.
	endpoint
		ifNotNil: [ aStream nextPutAll: ' - '.
			endpoint printOn: aStream ]