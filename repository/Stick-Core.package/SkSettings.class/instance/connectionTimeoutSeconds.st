accessing
connectionTimeoutSeconds
	^self at: #connectionTimeoutSeconds ifAbsentPut: [20]