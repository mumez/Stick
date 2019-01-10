event handling
onErrorSignaled: anError
	self stick isReleased ifTrue: [^self].
	self logger error: anError.
	(self portableUtil isNetworkError: anError)
		ifTrue: [self handleNetworkError ]
		ifFalse: [ self stick onErrorSignaled: anError ]