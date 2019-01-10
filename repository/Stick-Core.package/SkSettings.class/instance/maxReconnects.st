accessing
maxReconnects
	^self at: #maxReconnects ifAbsentPut: [3]