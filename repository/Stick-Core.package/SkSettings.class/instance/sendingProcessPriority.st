accessing
sendingProcessPriority
	^self at: #sendingProcessPriority ifAbsentPut: [Processor userSchedulingPriority - 5]