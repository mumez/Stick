accessing
reconnectIncrementRatio
	^self at: #reconnectIncrementRatio ifAbsentPut: [1.0]