accessing
reconnectIntervalSeconds
	^self at: #reconnectIntervalSeconds ifAbsentPut: [3]