accessing
receivingProcessPriority
	^self at: #receivingProcessPriority ifAbsentPut: [Processor userInterruptPriority]