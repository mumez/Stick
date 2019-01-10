startup-shutdown
startUp: isImageResuming
	^self allStickInstances do: [ :each |  
		isImageResuming ifTrue: [ each onImageResume]
	]