accessing
nameResolveTimeoutSeconds
	^self at: #nameResolveTimeoutSeconds ifAbsentPut: [20]