startup-shutdown
shutDown: isImageQuitting
	^self allStickInstances do: [ :each |  
		isImageQuitting ifTrue: [ each onImageQuit]
	]